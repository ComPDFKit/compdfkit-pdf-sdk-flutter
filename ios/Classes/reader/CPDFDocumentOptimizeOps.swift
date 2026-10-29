//
//  CPDFDocumentOptimizeOps.swift
//  compdfkit_flutter
//
//  Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
import Foundation
import Flutter
import ComPDFKit
import ComPDFKit_Tools

/// Handles document optimization, i.e. compression, on iOS. It mirrors Android
/// `DocumentOptimizeOps`: same channel methods, payload keys, defaults and error codes.
///
/// The native entry point is `CPDFOptimizeOption.optimizeAndSaveAsCopy(withPath:...)`. It is the
/// only iOS entry point that honours every option the channel carries (flags, image quality, the
/// color / grayscale / monochrome image settings and the ICC conversion) and reports timings.
///
/// The core optimizes the opened document itself before it serializes the copy, so the document
/// in memory holds the optimized content afterwards. Android closes the document for that reason;
/// iOS does not, which would let a later save overwrite the source file with the optimized
/// content. Every run that reached the native call therefore reloads the document from its source
/// file, exactly like Android does.
///
/// The SDK posts page progress as a global notification that does not say which document it
/// belongs to, so only one run may be in flight across all documents. Android only enforces one
/// run per document.
final class CPDFDocumentOptimizeOps {

    private static let errorDocumentInvalid = "DOCUMENT_INVALID"
    private static let errorInvalidOutputPath = "INVALID_OUTPUT_PATH"
    private static let errorInvalidOptions = "INVALID_OPTIMIZE_OPTIONS"
    private static let errorAlreadyRunning = "OPTIMIZE_ALREADY_RUNNING"
    private static let errorOptimizeFailed = "OPTIMIZE_FAILED"
    private static let errorRestoreFailed = "OPTIMIZE_RESTORE_FAILED"

    /// Mirrors `CPDFOptimizeFlag.defaults` in Dart and Android `DEFAULT_OPTIMIZE_FLAGS`.
    private static let defaultFlags: Int32 = 175_767_799
    private static let defaultImageQuality: Float = 40

    /// `CPDF_COMP_ALG` raw values from `CPDFOptimizeOption.h`. Raw values keep this independent
    /// of how Swift names the imported C enum cases.
    private static let algJpeg2000 = CPDF_COMP_ALG(rawValue: 1)!
    private static let algJpeg = CPDF_COMP_ALG(rawValue: 2)!
    private static let algJbig2 = CPDF_COMP_ALG(rawValue: 3)!

    /// The core defaults. The SDK getters cannot be used for this: a new `CPDFOptimizeOption`
    /// returns zeroed image options until they are set explicitly.
    private static let defaultColor = CPDFOptimizeImageOption(
        uperPpi: 225, targetPpi: 150, compAlg: algJpeg2000, quality: 40, blockSize: 256)
    private static let defaultGrayscale = defaultColor
    private static let defaultMonochrome = CPDFOptimizeImageOption(
        uperPpi: 450, targetPpi: 300, compAlg: algJbig2, quality: 40, blockSize: 256)

    private static let progressNotification =
        NSNotification.Name("CPDFDocumentOptimizeProgressDidUpdateNotification")

    private static let lock = NSLock()
    /// The option object of the run currently in flight, used by `cancel`.
    private static var running: CPDFOptimizeOption?

    private struct OptionsError: Error {
        let message: String
    }

    /// The SDK refused to create its option object; not a problem with the payload.
    private struct NativeOptionError: Error {}

    // MARK: - Channel entry points

    static func getOptimizeOptions(document: CPDFDocument?, result: FlutterResult) {
        guard document != nil else {
            result(FlutterError(code: errorDocumentInvalid, message: "The document is released or invalid.", details: nil))
            return
        }
        result([
            "flags": Int(defaultFlags),
            "image_quality": Double(defaultImageQuality),
            "color_image_options": encodeImageOptions(defaultColor),
            "grayscale_image_options": encodeImageOptions(defaultGrayscale),
            "monochrome_image_options": encodeImageOptions(defaultMonochrome),
            "color_space_convert": ["icc_data": NSNull(), "rgb_to_cmyk": true],
        ] as [String: Any])
    }

    /// Requests cancellation of the run in flight. Doing nothing when no run is in flight keeps
    /// the Dart side free of "is one running" bookkeeping, as on Android.
    static func cancel(result: FlutterResult) {
        lock.lock()
        let option = running
        lock.unlock()
        option?.isCanceled = true
        result(nil)
    }

    static func optimizeToFile(plugin: CPDFDocumentPlugin, call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let document = plugin.currentDocument else {
            result(FlutterError(code: errorDocumentInvalid, message: "The document is released or invalid.", details: nil))
            return
        }
        let info = call.arguments as? [String: Any]
        let outputPath = info?["output_path"] as? String ?? ""

        let savePath: String
        switch plugin.validatePdfStandardOutputPath(outputPath, document: document) {
        case .success(let path):
            savePath = path
        case .failure(let error):
            result(FlutterError(code: errorInvalidOutputPath, message: error.message, details: nil))
            return
        }
        guard let sourceURL = document.documentURL else {
            result(FlutterError(
                code: errorDocumentInvalid,
                message: "The document has no source file to restore it from after the run.",
                details: nil))
            return
        }

        let option: CPDFOptimizeOption
        do {
            option = try decodeOptions(info?["options"], document: document)
        } catch let error as OptionsError {
            result(FlutterError(code: errorInvalidOptions, message: error.message, details: nil))
            return
        } catch is NativeOptionError {
            result(FlutterError(code: errorOptimizeFailed, message: "The native optimize options could not be created.", details: nil))
            return
        } catch {
            result(FlutterError(code: errorInvalidOptions, message: "\(error)", details: nil))
            return
        }
        // `font_subset` is accepted for parity with Android but cannot be honoured yet:
        // optimizeAndSaveAsCopy always writes without font subsetting.

        lock.lock()
        if running != nil {
            lock.unlock()
            result(FlutterError(
                code: errorAlreadyRunning,
                message: "Another optimize run is already in flight. iOS allows one run at a time across all documents.",
                details: nil))
            return
        }
        running = option
        lock.unlock()

        // Pending ink and content edits are committed on the main thread first so they are part
        // of the optimized copy. Like every unsaved change they are still discarded by the
        // reload at the end, which is why callers are told to save first.
        let pdfListView = plugin.readerListView
        if let pdfListView = pdfListView {
            pdfListView.exitDrawing()
            if pdfListView.isEditing() && pdfListView.isEdited() {
                pdfListView.commitEditing()
            }
            if pdfListView.isEditing() {
                pdfListView.endOfEditing()
            }
        }
        let pageIndex = pdfListView?.currentPageIndex ?? 0
        let password = document.password
        let channel = plugin._methodChannel

        // The notification is posted synchronously on the thread running the core, so the
        // counter below is only ever touched from that one thread.
        var pagesProcessed = 0
        let observer = NotificationCenter.default.addObserver(
            forName: progressNotification, object: nil, queue: nil
        ) { notification in
            guard let index = (notification.userInfo?[CPDFOptimizeProgressPageIndexKey] as? NSNumber)?.intValue else {
                return
            }
            pagesProcessed = max(pagesProcessed, index + 1)
            DispatchQueue.main.async {
                channel.invokeMethod(CPDFConstants.onOptimizeProgress, arguments: ["page_index": index])
            }
        }
        option.startProgressMonitor()

        DispatchQueue.global(qos: .userInitiated).async {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: savePath) {
                try? fileManager.removeItem(atPath: savePath)
            }
            var stepsUs: Int64 = 0
            var saveUs: Int64 = 0
            let ok = option.optimizeAndSaveAsCopy(
                withPath: savePath, stepsMicroseconds: &stepsUs, saveMicroseconds: &saveUs)
            let cancelled = option.isCanceled
            if !ok && fileManager.fileExists(atPath: savePath) {
                // Never leave a partial copy behind.
                try? fileManager.removeItem(atPath: savePath)
            }
            let processed = pagesProcessed

            DispatchQueue.main.async {
                NotificationCenter.default.removeObserver(observer)
                let restoreError = restore(
                    plugin: plugin, sourceURL: sourceURL, password: password, pageIndex: pageIndex)

                var failure: String?
                if !ok && !cancelled {
                    failure = "The optimize run failed."
                }
                if let restoreError = restoreError {
                    // A failed reload outranks whatever else went wrong: the opened document
                    // still holds the optimized content, so saving it would overwrite the source.
                    result(FlutterError(
                        code: errorRestoreFailed,
                        message: failure.map { "\($0) \(restoreError)" } ?? restoreError,
                        details: nil))
                } else if let failure = failure {
                    result(FlutterError(code: errorOptimizeFailed, message: failure, details: nil))
                } else {
                    result([
                        "ok": ok,
                        "cancelled": cancelled,
                        "pages_processed": processed,
                        "steps_us": Int(stepsUs),
                        "save_us": Int(saveUs),
                    ] as [String: Any])
                }

                // Released last, after the result and the reload, so a follow-up run cannot
                // start while this one is still restoring the document.
                lock.lock()
                running = nil
                lock.unlock()
            }
        }
    }

    // MARK: - Restore

    /// Reopens the document from its source file and hands it to the plugin and the reader.
    ///
    /// - Returns: `nil` when the document was restored, otherwise why it was not.
    private static func restore(
        plugin: CPDFDocumentPlugin, sourceURL: URL, password: String?, pageIndex: Int
    ) -> String? {
        let warning = "Do not save it, the source file would be overwritten with the optimized content."
        guard let reloaded = CPDFDocument(url: sourceURL) else {
            return "The optimized document could not be reloaded from its original source. \(warning)"
        }
        if reloaded.isLocked {
            guard let password = password, !password.isEmpty, reloaded.unlock(withPassword: password) else {
                return "The optimized document could not be unlocked after reloading it. \(warning)"
            }
        }
        if let error = reloaded.error as NSError? {
            return "The optimized document could not be reloaded from its original source (native code \(error.code)). \(warning)"
        }
        plugin.replaceDocument(reloaded)
        if let pdfListView = plugin.readerListView {
            pdfListView.document = reloaded
            if reloaded.pageCount > 0 {
                pdfListView.go(toPageIndex: min(pageIndex, Int(reloaded.pageCount) - 1), animated: false)
            }
            pdfListView.setNeedsDisplay()
        }
        return nil
    }

    // MARK: - Codec

    /// Decodes the Dart payload. A missing payload or a missing entry falls back to the core
    /// defaults, the same values `get_optimize_options` reports.
    ///
    /// `imageQuality` is applied before the three image settings because its setter overwrites
    /// their quality; a per class quality therefore wins, as in the Android JNI layer.
    private static func decodeOptions(_ payload: Any?, document: CPDFDocument) throws -> CPDFOptimizeOption {
        guard let option = CPDFOptimizeOption(document: document) else {
            throw NativeOptionError()
        }
        var color = defaultColor
        var grayscale = defaultGrayscale
        var monochrome = defaultMonochrome
        var flags = defaultFlags
        var imageQuality = defaultImageQuality
        var iccData: Data?
        var rgbToCmyk = true

        if let payload = payload, !(payload is NSNull) {
            guard let map = payload as? [String: Any] else {
                throw OptionsError(message: "options must be a map.")
            }
            if let value = map["flags"] as? NSNumber {
                flags = value.int32Value
            }
            if let value = map["image_quality"] as? NSNumber {
                let quality = value.floatValue
                if quality < 0 || quality > 100 {
                    throw OptionsError(message: "image_quality must be between 0 and 100.")
                }
                imageQuality = quality
            }
            color = try decodeImageOptions(map["color_image_options"], fallback: color, field: "color_image_options")
            grayscale = try decodeImageOptions(map["grayscale_image_options"], fallback: grayscale, field: "grayscale_image_options")
            monochrome = try decodeImageOptions(map["monochrome_image_options"], fallback: monochrome, field: "monochrome_image_options")
            if let convert = map["color_space_convert"], !(convert is NSNull) {
                guard let convertMap = convert as? [String: Any] else {
                    throw OptionsError(message: "color_space_convert must be a map.")
                }
                switch convertMap["icc_data"] {
                case nil, is NSNull:
                    iccData = nil
                case let typed as FlutterStandardTypedData:
                    iccData = typed.data
                default:
                    throw OptionsError(message: "color_space_convert.icc_data must be bytes.")
                }
                if let value = convertMap["rgb_to_cmyk"] as? Bool {
                    rgbToCmyk = value
                }
            }
        }

        // C enums imported into Swift accept any raw value, so a combined mask is kept as is.
        option.optimizeflag = CPDF_OPTIMIZE_FLAG(rawValue: flags) ?? CPDF_OPTIMIZE_FLAG(rawValue: defaultFlags)!
        option.imageQuality = imageQuality
        option.col_imageOption = color
        option.gra_imageOption = grayscale
        option.mon_imageOption = monochrome
        option.iccProfileData = (iccData?.isEmpty ?? true) ? nil : iccData
        option.rgbToCMYK = rgbToCmyk
        return option
    }

    private static func decodeImageOptions(
        _ payload: Any?, fallback: CPDFOptimizeImageOption, field: String
    ) throws -> CPDFOptimizeImageOption {
        guard let payload = payload, !(payload is NSNull) else {
            return fallback
        }
        guard let map = payload as? [String: Any] else {
            throw OptionsError(message: "\(field) must be a map.")
        }
        var options = fallback
        options.uperPpi = try requirePositive(map["upper_ppi"], fallback: options.uperPpi, field: "\(field).upper_ppi")
        options.targetPpi = try requirePositive(map["target_ppi"], fallback: options.targetPpi, field: "\(field).target_ppi")
        options.blockSize = try requirePositive(map["block_size"], fallback: options.blockSize, field: "\(field).block_size")
        if let value = map["quality"] as? NSNumber {
            let quality = value.int32Value
            if quality < 0 || quality > 100 {
                throw OptionsError(message: "\(field).quality must be between 0 and 100.")
            }
            options.quality = quality
        }
        if let value = map["compress_algorithm"] as? String {
            options.compAlg = try algorithm(from: value, fallback: fallback.compAlg, field: field)
        }
        return options
    }

    private static func requirePositive(_ value: Any?, fallback: Int32, field: String) throws -> Int32 {
        guard let number = value as? NSNumber else {
            return fallback
        }
        let resolved = number.int32Value
        if resolved <= 0 {
            throw OptionsError(message: "\(field) must be greater than 0.")
        }
        return resolved
    }

    /// Maps the channel algorithm onto `CPDF_COMP_ALG` the way the Android JNI layer maps it onto
    /// the core: `flate` becomes JPEG 2000, and `none` / `run_length` keep the default algorithm
    /// of the image class. The wire format carries strings because the two SDKs number the
    /// algorithms differently.
    private static func algorithm(from value: String, fallback: CPDF_COMP_ALG, field: String) throws -> CPDF_COMP_ALG {
        switch value {
        case "jpeg2000", "flate":
            return algJpeg2000
        case "jpeg":
            return algJpeg
        case "jbig2":
            return algJbig2
        case "none", "run_length":
            return fallback
        default:
            throw OptionsError(message: "Unknown \(field).compress_algorithm: \(value)")
        }
    }

    private static func encodeImageOptions(_ options: CPDFOptimizeImageOption) -> [String: Any] {
        return [
            "upper_ppi": Int(options.uperPpi),
            "target_ppi": Int(options.targetPpi),
            "quality": Int(options.quality),
            "block_size": Int(options.blockSize),
            "compress_algorithm": channelValue(options.compAlg),
        ]
    }

    private static func channelValue(_ algorithm: CPDF_COMP_ALG) -> String {
        switch algorithm.rawValue {
        case algJpeg2000.rawValue:
            return "jpeg2000"
        case algJpeg.rawValue:
            return "jpeg"
        case algJbig2.rawValue:
            return "jbig2"
        default:
            return "none"
        }
    }
}
