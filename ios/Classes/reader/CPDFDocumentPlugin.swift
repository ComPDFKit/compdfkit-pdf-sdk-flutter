//
//  CPDFDocumentPlugin.swift
//  compdfkit_flutter
//  Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.

import Foundation
import UIKit
import ComPDFKit
import Flutter
import ComPDFKit_Tools

public class CPDFDocumentPlugin {
    
    private var document : CPDFDocument?
    
    public var _methodChannel : FlutterMethodChannel
    
    private var pdfViewController : CPDFViewController?
    
    
    /// The document the plugin currently operates on.
    var currentDocument: CPDFDocument? {
        return document
    }

    /// The list view of the attached reader, or `nil` when the document is not shown in one.
    var readerListView: CPDFListView? {
        return pdfViewController?.pdfListView
    }

    /// Swaps in a document reopened from its source file, e.g. after an optimize run.
    func replaceDocument(_ newDocument: CPDFDocument) {
        document = newDocument
    }

    init(uid : String, binaryMessager : FlutterBinaryMessenger) {
        _methodChannel = FlutterMethodChannel(name: "com.compdfkit.flutter.document_\(uid)", binaryMessenger: binaryMessager)
        registeryMethodChannel()
    }
    
    init(document: CPDFDocument, uid : String, binaryMessager : FlutterBinaryMessenger) {
        self.document = document
        _methodChannel = FlutterMethodChannel(name: "com.compdfkit.flutter.document_\(uid)", binaryMessenger: binaryMessager)
        registeryMethodChannel()
    }
    
    init(pdfViewController : CPDFViewController, uid : String, binaryMessager : FlutterBinaryMessenger){
        self.pdfViewController = pdfViewController
        _methodChannel = FlutterMethodChannel(name: "com.compdfkit.flutter.document_\(uid)", binaryMessenger: binaryMessager)
        registeryMethodChannel()
    }
    
    
    private func registeryMethodChannel(){
        
        _methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result:  @escaping FlutterResult) -> Void in
            print("ComPDFKit-Flutter: iOS-MethodChannel: CPDFDocumentPlugin [method:\(call.method)]")
            if let pdfViewController = self.pdfViewController,
               let newDocument = pdfViewController.pdfListView?.document,
               self.document !== newDocument {
                self.document = newDocument
            }
            
            switch call.method {
            case CPDFConstants.save:
                if #available(iOS 13.0, *) {
                    guard let window = UIApplication.shared.windows.first else { return }
                    window.overrideUserInterfaceStyle = .unspecified
                }
                let initInfo = call.arguments as? [String: Any]
                
                let isSaveIncremental = initInfo?["save_incremental"] as? Bool ?? true
                let fontSubset = initInfo?["font_sub_set"] as? Bool ?? true
                
                if(self.pdfViewController != nil){
                    // save pdf
                    guard let pdfListView = self.pdfViewController!.pdfListView else {
                        result(true)
                        return
                    }
                    // UI operations must be on main thread
                    pdfListView.exitDrawing()
                    pdfListView.becomeFirstResponder()

                    let isEditing = pdfListView.isEditing()
                    let isEdited = pdfListView.isEdited()

                    if isEditing == true && isEdited == true {
                        pdfListView.commitEditing()
                    }
                    if isEditing == true {
                        pdfListView.endOfEditing()
                    }

                    guard let document = pdfListView.document else {
                        result(false)
                        return
                    }

                    let isModified = document.isModified()
                    let documentURL = document.documentURL

                    // Perform file I/O on background thread
                    DispatchQueue.global(qos: .userInitiated).async {
                        var isSuccess = false
                        if isModified == true {
                            isSuccess = document.write(to: documentURL, isSaveFontSubset: fontSubset)
                        }

                        // Return result on main thread
                        DispatchQueue.main.async {
                            if isSuccess {
                                self._methodChannel.invokeMethod("saveDocument", arguments: nil)
                            }
                            result(isSuccess)
                        }
                    }
                } else {
                    guard let document = self.document else {
                        result(false)
                        return
                    }

                    let isModified = document.isModified()
                    let documentURL = document.documentURL

                    // Perform file I/O on background thread
                    DispatchQueue.global(qos: .userInitiated).async {
                        var isSuccess = false
                        if isModified == true {
                            isSuccess = document.write(to: documentURL, isSaveFontSubset: fontSubset)
                        }

                        // Return result on main thread
                        DispatchQueue.main.async {
                            result(isSuccess)
                        }
                    }
                }
                
            case CPDFConstants.openDocument:
                let initInfo = call.arguments as? [String: Any]
                let path = initInfo?["filePath"] as? String ?? ""
                let password = initInfo?["password"] ?? ""
                
                self.document = CPDFDocument(url: URL(fileURLWithPath: path))
                if(self.document?.isLocked == true){
                    let success = self.document?.unlock(withPassword: password as? String ?? "")
                    if(success == true){
                        if let error = self.document?.error as? NSError {
                            let code = error.code
                            
                            switch code {
                            case CPDFDocumentUnknownError:
                                result("unknown")
                            case CPDFDocumentFileError:
                                result("errorFile")
                            case CPDFDocumentFormatError:
                                result("errorFormat")
                            case CPDFDocumentPasswordError:
                                result("errorPassword")
                            case CPDFDocumentSecurityError:
                                result("errorSecurity")
                            case CPDFDocumentPageError:
                                result("errorPage")
                            default:
                                result("success")
                            }
                        } else {
                            result("success")
                        }
                        
                    }else {
                        result("errorPassword")
                    }
                } else {
                    if let error = self.document?.error as? NSError {
                        let code = error.code
                        
                        switch code {
                        case CPDFDocumentUnknownError:
                            result("unknown")
                        case CPDFDocumentFileError:
                            result("errorFile")
                        case CPDFDocumentFormatError:
                            result("errorFormat")
                        case CPDFDocumentPasswordError:
                            result("errorPassword")
                        case CPDFDocumentSecurityError:
                            result("errorSecurity")
                        case CPDFDocumentPageError:
                            result("errorPage")
                        default:
                            result("success")
                        }
                    } else {
                        result("success")
                    }
                }
                self.pdfViewController?.pdfListView?.document = self.document
                self.pdfViewController?.pdfListView?.setNeedsDisplay()
                
            case CPDFConstants.getFileName:
                if(self.document == nil){
                    print("self.document is nil")
                    result("is nil")
                    return
                }
                let fileName = self.document?.documentURL.lastPathComponent
                result(fileName)
            case CPDFConstants.isEncrypted:
                let isEncrypted = self.document?.isEncrypted ?? false
                result(isEncrypted)
            case CPDFConstants.isImageDoc:
                let isImageDoc = self.document?.isImageDocument() ?? false
                result(isImageDoc)
            case CPDFConstants.getPermissions:
                let permissions = self.document?.permissionsStatus ?? .none
                switch permissions {
                case .none:
                    result(0)
                case .user:
                    result(1)
                case .owner:
                    result(2)
                default:
                    result(0)
                }
            case CPDFConstants.checkOwnerUnlocked:
                let owner = self.document?.isCheckOwnerUnlocked() ?? false
                result(owner)
            case CPDFConstants.checkOwnerPassword:
                let info = call.arguments as? [String: Any]
                let password = info?["password"] as? String ?? ""
                let isOwnerPassword = self.document?.checkOwnerPassword(password) ?? false
                result(isOwnerPassword)
            case CPDFConstants.close:
                self.document = nil
                self._methodChannel.setMethodCallHandler(nil)
                result(true)
            case CPDFConstants.hasChange:
                let isModified = self.document?.isModified() ?? false
                result(isModified)
            case CPDFConstants.importAnnotations:
                let importPath = call.arguments as? String ?? ""
                let success = self.document?.importAnnotation(fromXFDFPath: importPath) ?? false
                if success {
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                }
                result(success)
            case CPDFConstants.exportAnnotations:
                let fileNameWithExtension = self.document?.documentURL.lastPathComponent ?? ""
                let fileName = (fileNameWithExtension as NSString).deletingPathExtension
                let documentFolder = NSHomeDirectory().appending("/Documents/\(fileName)_xfdf.xfdf")
                let succes = self.document?.exportAnnotation(toXFDFPath: documentFolder) ?? false
                if succes {
                    result(documentFolder)
                } else {
                    result("")
                }
            case CPDFConstants.removeAllAnnotations:
                let pageCount = self.document?.pageCount ?? 0
                for i in 0..<pageCount {
                    let page = self.document?.page(at: i)
                    page?.removeAllAnnotations()
                }
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                self.pdfViewController?.pdfListView?.updateActiveAnnotations([])
                
                result(true)
            case CPDFConstants.getPageCount:
                let count = self.document?.pageCount ?? 1
                result(count)
            case CPDFConstants.saveAs:
                let info = call.arguments as? [String: Any]
                
                let savePath = self.getValue(from: info, key: "save_path", defaultValue: "") ?? ""
                
                let removeSecurity = self.getValue(from: info, key: "remove_security", defaultValue: false)
                
                let fontSubSet = self.getValue(from: info, key: "font_sub_set", defaultValue: true)
                
                guard let document = self.document else {
                    result(false)
                    return
                }

                // UI operations on main thread
                let isEditing = self.pdfViewController?.pdfListView?.isEditing() == true
                let isEdited = self.pdfViewController?.pdfListView?.isEdited() == true

                if isEditing && isEdited {
                    self.pdfViewController?.pdfListView?.commitEditing()
                }

                let saveURL = URL(fileURLWithPath: savePath)

                // Perform file I/O on background thread
                DispatchQueue.global(qos: .userInitiated).async {
                    var success = false
                    if removeSecurity {
                        success = document.writeDecrypt(to: saveURL, isSaveFontSubset: fontSubSet)
                    } else {
                        success = document.write(to: saveURL, isSaveFontSubset: fontSubSet)
                    }

                    // Return result on main thread
                    DispatchQueue.main.async {
                        result(success)
                    }
                }
            case CPDFConstants.print:
                self.pdfViewController?.enterPrintState()
                result(nil)
            case CPDFConstants.removePassword:
                let url = self.document?.documentURL
                let success = self.document?.writeDecrypt(to: url, isSaveFontSubset: true) ?? false
                result(success)
            case CPDFConstants.setPassword:
                let info = call.arguments as? [String: Any]
                let userPassword : String = self.getValue(from: info, key: "user_password", defaultValue: "")
                let ownerPassword : String = self.getValue(from: info, key: "owner_password", defaultValue: "")
                let allowsPrinting : Bool = self.getValue(from: info, key: "allows_printing", defaultValue: true)
                let allowsCopying : Bool = self.getValue(from: info, key: "allows_copying", defaultValue: true)
                
                let encryptAlgo : String = self.getValue(from: info, key: "encrypt_algo", defaultValue: "rc4")
                
                var level: Int = 0
                // Encryption mode, the type passed in is：rc4, aes128, aes256, noEncryptAlgo
                switch encryptAlgo {
                case "rc4":
                    level = 0
                case "aes128":
                    level = 1
                case "aes256":
                    level = 2
                case "noEncryptAlgo":
                    level = 3
                default:
                    level = 3
                }
                
                var options:[CPDFDocumentWriteOption: Any] = [:]
                options[CPDFDocumentWriteOption.userPasswordOption] = userPassword
                
                options[CPDFDocumentWriteOption.ownerPasswordOption] = ownerPassword
                
                options[CPDFDocumentWriteOption.allowsPrintingOption] = allowsPrinting
                
                options[CPDFDocumentWriteOption.allowsCopyingOption] = allowsCopying
                
                options[CPDFDocumentWriteOption.encryptionLevelOption] = NSNumber(value: level)
                
                let url = self.document?.documentURL
                
                let success = self.document?.write(to: url, withOptions: options, isSaveFontSubset: true)
                
                result(success)
            case CPDFConstants.getEncryptAlgorithm:
                let level: CPDFDocumentEncryptionLevel = self.document?.encryptionLevel ?? .noEncryptAlgo
                switch level {
                case .RC4:
                    result("rc4")
                case .AES128:
                    result("aes128")
                case .AES256:
                    result("aes256")
                case .noEncryptAlgo:
                    result("noEncryptAlgo")
                @unknown default:
                    result("noEncryptAlgo")
                }
            case CPDFConstants.getHeaderFooter:
                result(self.headerFooterMap())
            case CPDFConstants.updateHeaderFooter:
                self.updateHeaderFooter(call: call, result: result)
            case CPDFConstants.clearHeaderFooter:
                guard let headerFooter = self.document?.headerFooter() else {
                    result(false)
                    return
                }
                let success = headerFooter.clear()
                if success {
                    self.pdfViewController?.pdfListView?.layoutDocumentView()
                }
                result(success)
            case CPDFConstants.getPdfStandardType:
                guard let document = self.document else {
                    result(FlutterError(code: "DOCUMENT_INVALID", message: "The document is released or invalid.", details: nil))
                    return
                }
                result(CPDFPdfStandardUtil.value(from: document.standardType()))
            case CPDFConstants.convertToPdfStandard:
                self.convertToPdfStandard(call: call, result: result)
            case CPDFConstants.getOptimizeOptions:
                CPDFDocumentOptimizeOps.getOptimizeOptions(document: self.document, result: result)
            case CPDFConstants.optimizeDocumentToFile:
                CPDFDocumentOptimizeOps.optimizeToFile(plugin: self, call: call, result: result)
            case CPDFConstants.cancelOptimize:
                CPDFDocumentOptimizeOps.cancel(result: result)
            case CPDFConstants.getBates:
                result(self.batesMap())
            case CPDFConstants.updateBates:
                self.updateBates(call: call, result: result)
            case CPDFConstants.clearBates:
                guard let bates = self.document?.bates() else {
                    result(false)
                    return
                }
                let batesClearResult = bates.clear()
                self.pdfViewController?.pdfListView?.layoutDocumentView()
                result(batesClearResult)
            case CPDFConstants.getBackground:
                result(self.backgroundMap())
            case CPDFConstants.updateBackground:
                self.updateBackground(call: call, result: result)
            case CPDFConstants.clearBackground:
                guard let background = self.document?.background(),
                      background.hasBackground else {
                    result(false)
                    return
                }
                let success = background.clear()
                if success {
                    self.pdfViewController?.pdfListView?.layoutDocumentView()
                }
                result(success)
            case CPDFConstants.getDigitalSignatures:
                self.getDigitalSignatures(result: result)
            case CPDFConstants.verifyDigitalSignatureDocument:
                self.verifyDigitalSignature(call: call, result: result)
            case CPDFConstants.getLtvReadiness:
                self.getLtvReadiness(result: result)
            case CPDFConstants.addSignatureLtv:
                self.addSignatureLtv(call: call, result: result)
            case CPDFConstants.createWatermark:
                self.createWatermark(call: call, result: result)
            case CPDFConstants.removeAllWatermark:
                let watrmarks = self.document?.watermarks() ?? []
                for watermark in watrmarks {
                    self.document?.removeWatermark(watermark)
                }
                self.pdfViewController?.pdfListView?.layoutDocumentView()
                result(nil)
            case CPDFConstants.getWatermarkCount:
                result(self.document?.watermarks()?.count ?? 0)
            case CPDFConstants.getWatermark:
                self.getWatermark(call: call, result: result)
            case CPDFConstants.getWatermarks:
                let info = call.arguments as? [String: Any]
                let exportImages: Bool = self.getValue(from: info, key: "export_images", defaultValue: false)
                let watermarks = self.document?.watermarks() ?? []
                result(watermarks.enumerated().map { index, watermark in
                    self.toWatermarkMap(watermark, index: index, exportImage: exportImages)
                })
            case CPDFConstants.updateWatermark:
                self.updateWatermark(call: call, result: result)
            case CPDFConstants.removeWatermark:
                self.removeWatermark(call: call, result: result)
            case CPDFConstants.importWidgets:
                let importPath = call.arguments as? String ?? ""
                
                let success = self.document?.importForm(fromXFDFPath: importPath) ?? false
                if success {
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                }
                result(success)
            case CPDFConstants.exportWidgets:
                let fileNameWithExtension = self.document?.documentURL.lastPathComponent ?? ""
                let fileName = (fileNameWithExtension as NSString).deletingPathExtension
                let documentFolder = NSHomeDirectory().appending("/Documents/\(fileName)_xfdf.xfdf")
                let succes = self.document?.export(toXFDFPath: documentFolder) ?? false
                if succes {
                    result(documentFolder)
                } else {
                    result("")
                }
            case CPDFConstants.flattenAllPages:
                let info = call.arguments as? [String: Any]
                
                let savePath : String = self.getValue(from: info, key: "save_path", defaultValue: "")
                
                let fontSubset : Bool = self.getValue(from: info, key: "font_subset", defaultValue: true)
                
                let success = self.document?.writeFlatten(to: URL(fileURLWithPath: savePath), isSaveFontSubset: fontSubset)
                
                result(success)
            case CPDFConstants.importDocument:
                let info = call.arguments as? [String: Any]
                
                let filePath : String = self.getValue(from: info, key: "file_path", defaultValue: "")
                
                let pages : [Int] = self.getValue(from: info, key: "pages", defaultValue: [])
                
                var insertPosition = self.getValue(from: info, key: "insert_position", defaultValue: -1)
                
                let password = self.getValue(from: info, key: "password", defaultValue: "")
                
                let _document = CPDFDocument(url: URL(fileURLWithPath: filePath))
                
                if _document?.isLocked == true {
                    _document?.unlock(withPassword: password)
                }
                
                var _index = insertPosition
                if insertPosition < 0 || insertPosition > self.document?.pageCount ?? 0 {
                    if insertPosition == -1 {
                        _index = Int(self.document?.pageCount ?? 0)
                    } else {
                        result(false)
                    }
                }
                
                var indexSet = IndexSet()
                for page in pages {
                    indexSet.insert(IndexSet.Element(page))
                }
                
                let success = self.document?.importPages(indexSet, from: _document, at: UInt(_index))
                self.pdfViewController?.pdfListView?.layoutDocumentView()
                
                result(success)
            case CPDFConstants.insertBlankPage:
                let info = call.arguments as? [String: Any]
                
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                
                let pageWidth = self.getValue(from: info, key: "page_width", defaultValue: 0)
                
                let pageHeight = self.getValue(from: info, key: "page_height", defaultValue: 0)
                
                var _index = pageIndex
                if pageIndex < 0 || pageIndex > self.document?.pageCount ?? 0 {
                    if pageIndex == -1 {
                        _index = Int(self.document?.pageCount ?? 0)
                    } else {
                        result(false)
                    }
                }
                
                let size = CGSize(width: pageWidth, height: pageHeight)
                let success = self.document?.insertPage(size, at: UInt(_index))
                //                self.pdfViewController?.pdfListView?.layoutDocumentView()
                
                result(success)
            case CPDFConstants.insertPageWithImagePath:
                let info = call.arguments as? [String: Any]
                
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                
                let pageWidth = self.getValue(from: info, key: "page_width", defaultValue: 0)
                
                let pageHeight = self.getValue(from: info, key: "page_height", defaultValue: 0)
                
                let imagePath = self.getValue(from: info, key: "image_path", defaultValue: "")
                if(imagePath.isEmpty){
                    result(["error": "image path is empty"])
                    return
                }
                let size = CGSize(width: pageWidth, height: pageHeight)
                
                let success = self.document?.insertPage(size, withImage: imagePath, at: UInt(pageIndex))
                result(success)
            case CPDFConstants.copyPage:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                var insertIndex = self.getValue(from: info, key: "insert_index", defaultValue: -1)
                guard let document = self.document else {
                    result(false)
                    return
                }

                let pageCount = Int(document.pageCount)
                guard pageIndex >= 0 && pageIndex < pageCount else {
                    result(false)
                    return
                }

                if insertIndex == -1 {
                    insertIndex = pageCount
                }
                guard insertIndex >= 0 && insertIndex <= pageCount else {
                    result(false)
                    return
                }

                var sourceIndexSet = IndexSet()
                sourceIndexSet.insert(pageIndex)

                guard let copiedDocument = CPDFDocument() else {
                    result(false)
                    return
                }

                let copySuccess = copiedDocument.importPages(sourceIndexSet, from: document, at: 0)
                guard copySuccess else {
                    result(false)
                    return
                }

                var copiedIndexSet = IndexSet()
                copiedIndexSet.insert(0)
                let success = document.importPages(copiedIndexSet, from: copiedDocument, at: UInt(insertIndex))
                if success {
                    self.pdfViewController?.pdfListView?.layoutDocumentView()
                }
                result(success)
            case CPDFConstants.splitDocumentPages:
                let info = call.arguments as? [String: Any]
                
                let savePath = self.getValue(from: info, key: "save_path", defaultValue: "")
                
                let pages : [Int] = self.getValue(from: info, key: "pages", defaultValue: [])
                
                var indexSet = IndexSet()
                for page in pages {
                    indexSet.insert(page)
                }
                
                let document = CPDFDocument()
                document?.importPages(indexSet, from: self.document, at: 0)
                
                let success = document?.write(to: URL(fileURLWithPath: savePath), isSaveFontSubset: true) ?? false
                result(success)
            case CPDFConstants.extractImages:
                self.extractImages(call: call, result: result)
            case CPDFConstants.getDocumentPath:
                let path = self.document?.documentURL.path ?? ""
                result(path)
            case CPDFConstants.removeAnnotation:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                
                pageUtil.removeAnnotation(uuid: uuid)
                
                self.pdfViewController?.pdfListView?.updateActiveAnnotations([])
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                result(true)
            case CPDFConstants.removeWidget:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                
                pageUtil.removeWidget(uuid: uuid)
                
                self.pdfViewController?.pdfListView?.updateActiveAnnotations([])
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                self.pdfViewController?.pdfListView?.updateFormScrollEnabled()
                result(true)
            case CPDFConstants.removeEditArea:
                let mode = call.arguments as? [String: Any] ?? [:]
                let pageIndex = mode["page"] as? Int ?? 0
                let uuid = mode["uuid"] as? String ?? ""
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pdfView = self.pdfViewController?.pdfListView
                
                let editArea = pageUtil.getEidtArea(editUUID: uuid) ?? CPDFEditArea()
                self.pdfViewController?.pdfListView?.remove(with: editArea)
                result(nil)
            case CPDFConstants.getAnnotations:
                let pageIndex = call.arguments as? Int ?? 0
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                let annotations = pageUtil.getAnnotations()
                
                result(annotations)
            case CPDFConstants.addAnnotationReply:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let content = self.getValue(from: info, key: "content", defaultValue: "")
                let title = self.getValue(from: info, key: "title", defaultValue: "")
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                if let reply = pageUtil.addAnnotationReply(uuid: uuid, content: content, title: title) {
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                    result(reply)
                } else {
                    result(nil)
                }
            case CPDFConstants.getAnnotationReplies:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                result(pageUtil.getAnnotationReplies(uuid: uuid))
            case CPDFConstants.updateAnnotationReply:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let nativeId = info?["native_id"] as? String
                let replyKey = info?["reply_key"] as? String
                let parentUuid = info?["parent_uuid"] as? String
                let content = self.getValue(from: info, key: "content", defaultValue: "")
                let title = info?["title"] as? String
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                let success = pageUtil.updateAnnotationReply(
                    uuid: uuid,
                    nativeId: nativeId,
                    replyKey: replyKey,
                    parentUuid: parentUuid,
                    content: content,
                    title: title
                )
                if success {
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                }
                result(success)
            case CPDFConstants.removeAnnotationReply:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let nativeId = info?["native_id"] as? String
                let replyKey = info?["reply_key"] as? String
                let parentUuid = info?["parent_uuid"] as? String
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                let success = pageUtil.removeAnnotationReply(
                    uuid: uuid,
                    nativeId: nativeId,
                    replyKey: replyKey,
                    parentUuid: parentUuid
                )
                if success {
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                }
                result(success)
            case CPDFConstants.removeAllAnnotationReplies:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                let success = pageUtil.removeAllAnnotationReplies(uuid: uuid)
                if success {
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                }
                result(success)
            case CPDFConstants.setAnnotationMarkState:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let nativeId = info?["native_id"] as? String
                let replyKey = info?["reply_key"] as? String
                let parentUuid = info?["parent_uuid"] as? String
                let state = self.getValue(from: info, key: "mark_state", defaultValue: "")
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                result(pageUtil.setAnnotationMarkState(
                    uuid: uuid,
                    nativeId: nativeId,
                    replyKey: replyKey,
                    parentUuid: parentUuid,
                    state: state
                ))
            case CPDFConstants.getAnnotationMarkState:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let nativeId = info?["native_id"] as? String
                let replyKey = info?["reply_key"] as? String
                let parentUuid = info?["parent_uuid"] as? String
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                result(pageUtil.getAnnotationMarkState(
                    uuid: uuid,
                    nativeId: nativeId,
                    replyKey: replyKey,
                    parentUuid: parentUuid
                ))
            case CPDFConstants.setAnnotationReviewState:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let nativeId = info?["native_id"] as? String
                let replyKey = info?["reply_key"] as? String
                let parentUuid = info?["parent_uuid"] as? String
                let state = self.getValue(from: info, key: "review_state", defaultValue: "")
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                result(pageUtil.setAnnotationReviewState(
                    uuid: uuid,
                    nativeId: nativeId,
                    replyKey: replyKey,
                    parentUuid: parentUuid,
                    state: state
                ))
            case CPDFConstants.getAnnotationReviewState:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let nativeId = info?["native_id"] as? String
                let replyKey = info?["reply_key"] as? String
                let parentUuid = info?["parent_uuid"] as? String
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                result(pageUtil.getAnnotationReviewState(
                    uuid: uuid,
                    nativeId: nativeId,
                    replyKey: replyKey,
                    parentUuid: parentUuid
                ))
            case CPDFConstants.getWidgets:
                let pageIndex = call.arguments as? Int ?? 0
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                let widgets = pageUtil.getForms()
                result(widgets)
                
            case CPDFConstants.getOutlineRoot:
                result(CPDFOutlineUtil.getOutline(self.document))
                
            case CPDFConstants.newOutlineRoot:
                result(CPDFOutlineUtil.newOutlineRoot(document: self.document))
            
            case CPDFConstants.addOutline:
                let info = call.arguments as? [String: Any]
                let parentUuid = self.getValue(from: info, key: "parent_uuid", defaultValue: "")
                let insertIndex = self.getValue(from: info, key: "insert_index", defaultValue: 0)
                let title = self.getValue(from: info, key: "title", defaultValue: "")
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                result(CPDFOutlineUtil.addOutline(document: self.document, parentUuid: parentUuid, insertIndex: insertIndex, title: title, pageIndex: pageIndex))
                
            case CPDFConstants.updateOutline:
                let info = call.arguments as? [String: Any]
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let title = self.getValue(from: info, key: "title", defaultValue: "")
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let updateResult = CPDFOutlineUtil.updateOutline(document: self.document, uuid: uuid, title: title, pageIndex: pageIndex)
                result(updateResult)
                
            case CPDFConstants.removeOutline:
                let uuid = call.arguments as? String ?? ""
                let removeResult = CPDFOutlineUtil.removeOutline(document: self.document, uuid: uuid)
                result(removeResult)
                
            case CPDFConstants.moveToOutline:
                let info = call.arguments as? [String: Any]
                let newParentUuid = self.getValue(from: info, key: "new_parent_uuid", defaultValue: "")
                let insertIndex = self.getValue(from: info, key: "insert_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let moveResult = CPDFOutlineUtil.moveToOutline(document: self.document, newParentUUid: newParentUuid,uuid: uuid, insertIndex: insertIndex)
                result(moveResult)
                
            case CPDFConstants.removeBookmark:
                let pageIndex = call.arguments as? Int ?? 0
                let removeResult = self.document?.removeBookmark(forPageIndex: UInt(pageIndex)) ?? false
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                result(removeResult)
            
            case CPDFConstants.getBookmark:
                result(CPDFBookmarkUtil.getBookmarks(document:self.document))
                
            case CPDFConstants.hasBookmark:
                let pageIndex = call.arguments as? Int ?? 0
                let bookmarks = self.document?.bookmarks() ?? []
                let hasBookmark = bookmarks.contains { $0.pageIndex == UInt(pageIndex) }
                result(hasBookmark)
                
            case CPDFConstants.addBookmark:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let title = self.getValue(from: info, key: "title", defaultValue: "")
                let addBookmarkResult = self.document?.addBookmark(title, forPageIndex: UInt(pageIndex))
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                result(addBookmarkResult ?? false)

            case CPDFConstants.updateBookmark:
                let info = call.arguments as? [String: Any]
                let title = self.getValue(from: info, key: "title", defaultValue: "")
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                result(CPDFBookmarkUtil.updateBookmark(document: self.document, uuid: uuid, title: title))
                
            case CPDFConstants.getPageSize:
                let pageIndex = call.arguments as? Int ?? 0
                
                guard let document = self.document else {
                    result(["error": "document is nil"])
                    return
                }
                guard pageIndex >= 0 && pageIndex < document.pageCount else {
                    result(["error": "pageIndex out of range"])
                    return
                }
                if let page = document.page(at: UInt(pageIndex)) {
                    let size = page.bounds(for: .mediaBox).size
                    let pageSize: [String: CGFloat] = [
                        "width": size.width,
                        "height": size.height
                    ]
                    result(pageSize)
                } else {
                    result(["error": "page not found"])
                }
                
            case CPDFConstants.renderPage:
                let info = call.arguments as? [String: Any]
                
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let renderWidth = self.getValue(from: info, key: "width", defaultValue: 0)
                let renderHeight = self.getValue(from: info, key: "height", defaultValue: 0)
                let compression = self.getValue(from: info, key: "compression", defaultValue: "png")
                let backgroundColor = self.getValue(from: info, key: "background_color", defaultValue: "#FFFFFF")
                let drawAnnot = self.getValue(from: info, key: "draw_annot", defaultValue: true)
                let drawForm = self.getValue(from: info, key: "draw_form", defaultValue: true)
                // TODO: Apply backgroundColor, drawAnnot, and drawForm when the iOS native renderer supports these options.
                _ = backgroundColor
                _ = drawAnnot
                _ = drawForm
                print("getPageImageBytes pageIndex:\(pageIndex), width:\(renderWidth), height:\(renderHeight)")
                guard let document = self.document else {
                    result(["error": "document is nil"])
                    return
                }
                
                guard pageIndex >= 0 && pageIndex < document.pageCount else {
                    result(["error": "pageIndex out of range"])
                    return
                }
                
                let page = document.page(at: UInt(pageIndex))

                DispatchQueue.global(qos: .userInitiated).async {
                    let thumbnailSize = CGSize(width: renderWidth, height: renderHeight)
                    let image = page?.thumbnail(of: thumbnailSize)
                    if(image == nil) {
                        result(["error": "failed to render thumbnail"])
                        return;
                    }
                    var data: Data
                    switch(compression) {
                    case "png":
                        data = image!.pngData()!
                    case "jpeg":
                        data = image!.jpegData(compressionQuality: 0.85)!
                    default:
                        data = image!.pngData()!
                    }
                    result(data)

                }
            case CPDFConstants.renderAnnotationAppearance:
                self.renderAnnotationAppearance(call: call, result: result)
            case CPDFConstants.getPageRotaion:
                let pageIndex = call.arguments as? Int ?? 0
                guard let page = self.document?.page(at: UInt(pageIndex)) else {
                    result(["GET_PAGE_ROTATION_FAIL", "Page not found at index: \(pageIndex)"])
                    return
                }
                
                result(page.rotation)
            case CPDFConstants.setPageRotation:
                let info = call.arguments as? [String: Any]
                
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let rotation = self.getValue(from: info, key: "rotation", defaultValue: 0)
                guard let page = self.document?.page(at: UInt(pageIndex)) else {
                    result(["GET_PAGE_ROTATION_FAIL", "Page not found at index: \(pageIndex)"])
                    return
                }
                page.rotation = rotation
                result(true)
            case CPDFConstants.removePages:
                let pages = call.arguments as? [Int] ?? []
                if(pages.isEmpty){
                    result(FlutterError(code: "REMOVE_PAGES_FAIL", message: "The page range cannot be empty, please set the page range, for example: pages: [0,1,2,3]", details: nil))
                    return;
                }
                var indexSet = IndexSet()
                for page in pages {
                    indexSet.insert(page)
                }
                let success = self.document?.removePage(at: indexSet)
                result(success)
            case CPDFConstants.movePage:
                let info = call.arguments as? [String: Any]
                let fromIndex = self.getValue(from: info, key: "from_index", defaultValue: 0)
                let toIndex = self.getValue(from: info, key: "to_index", defaultValue: 0)
                let success = self.document?.movePage(at: UInt(fromIndex), withPageAt: UInt(toIndex))
                result(success)
            case CPDFConstants.getDocumentInfo:
                result(CPDFDocumentInfoUtil.getDocumentInfo(from: self.document))
                
            case CPDFConstants.getMajorVersion:
                result(self.document?.majorVersion ?? 0)
                
            case CPDFConstants.getMinorVersion:
                result(self.document?.minorVersion ?? 0)
                
            case CPDFConstants.getPermissionsInfo:
                result(CPDFDocumentInfoUtil.getPermissionsInfo(document: self.document!))
                
            case CPDFConstants.isLocked:
                result(self.document?.isLocked ?? false)
                
            case CPDFConstants.searchText:
                let info = call.arguments as? [String: Any]
                let keywords = self.getValue(from: info, key: "keywords", defaultValue: "")
                let options = self.getValue(from: info, key: "search_options", defaultValue: CPDFSearchOptions(rawValue: 0))
                let searchResults = CPDFSearchUtil.searchText(from: self.document, keywords: keywords, options: options)
                result(searchResults)
                
            case CPDFConstants.searchTextSelection:
                let info = call.arguments as? [String: Any]
                let selection = CPDFSearchUtil.selection(from: self.document, info: info!)
                if let selection = selection {
                    self.pdfViewController?.pdfListView?.go(to: selection.bounds, on: selection.page, offsetY: CGFloat(88), animated: false)
                    self.pdfViewController?.pdfListView?.setHighlightedSelection(selection, animated: true)
                }
                result(nil)
                
            case CPDFConstants.searchTextClear:
                self.pdfViewController?.pdfListView?.setHighlightedSelection(nil, animated: false)
                result(nil)
                
            case CPDFConstants.getSearchText:
                let info = call.arguments as? [String: Any]
                result(CPDFSearchUtil.getSearchText(from: self.document, info: info!))

            case CPDFConstants.getPageText:
                let info = call.arguments as? [String: Any]
                guard let pageIndex = self.validatedPageIndex(
                    from: info,
                    errorCode: "GET_PAGE_TEXT_FAIL",
                    result: result
                ) else {
                    return
                }
                result(CPDFPageTextUtil.getPageText(from: self.document, pageIndex: pageIndex))

            case CPDFConstants.getPageTextInRect:
                let info = call.arguments as? [String: Any]
                guard let pageIndex = self.validatedPageIndex(
                    from: info,
                    errorCode: "GET_PAGE_TEXT_IN_RECT_FAIL",
                    result: result
                ) else {
                    return
                }
                result(CPDFPageTextUtil.getPageTextInRect(
                    from: self.document,
                    pageIndex: pageIndex,
                    rectInfo: info?["rect"] as? [String: Any]
                ))

            case CPDFConstants.getPageTextLines:
                let info = call.arguments as? [String: Any]
                guard let pageIndex = self.validatedPageIndex(
                    from: info,
                    errorCode: "GET_PAGE_TEXT_LINES_FAIL",
                    result: result
                ) else {
                    return
                }
                result(CPDFPageTextUtil.getPageTextLines(from: self.document, pageIndex: pageIndex))
                
            case CPDFConstants.updateAnnotation:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let properties = self.getValue(from: info, key: "data", defaultValue: [String:Any]())
                
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                pageUtil.updateAnnotation(pageIndex: pageIndex, uuid: uuid, properties: properties)
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                result(true)

            case CPDFConstants.applyRedaction:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: -1)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                guard let document = self.document,
                      pageIndex >= 0,
                      pageIndex < document.pageCount,
                      !uuid.isEmpty,
                      let page = document.page(at: UInt(pageIndex)) else {
                    result(FlutterError(
                        code: "APPLY_REDACTION_FAIL",
                        message: "Redaction arguments are invalid.",
                        details: nil
                    ))
                    return
                }
                let pageUtil = CPDFPageUtil(page: page)
                guard let redaction = pageUtil.getAnnotation(formUUID: uuid)
                        as? CPDFRedactAnnotation else {
                    result(FlutterError(
                        code: "APPLY_REDACTION_FAIL",
                        message: "Redaction annotation not found.",
                        details: nil
                    ))
                    return
                }
                let redactionCount = page.annotations.filter {
                    $0 is CPDFRedactAnnotation
                }.count
                redaction.applyRedaction()
                page.reloadAnnotations()
                guard page.annotations.filter({ $0 is CPDFRedactAnnotation }).count
                        < redactionCount else {
                    result(FlutterError(
                        code: "APPLY_REDACTION_FAIL",
                        message: "Failed to apply redaction.",
                        details: nil
                    ))
                    return
                }
                self.pdfViewController?.pdfListView?.layoutDocumentView()
                result(nil)

            case CPDFConstants.applyRedactions:
                guard let document = self.document else {
                    result(FlutterError(
                        code: "APPLY_REDACTION_FAIL",
                        message: "Document is unavailable.",
                        details: nil
                    ))
                    return
                }
                var redactionCount = 0
                for pageIndex in 0..<document.pageCount {
                    if let page = document.page(at: UInt(pageIndex)) {
                        redactionCount += page.annotations.filter {
                            $0 is CPDFRedactAnnotation
                        }.count
                    }
                }
                document.applyRedactions()
                var remainingRedactionCount = 0
                for pageIndex in 0..<document.pageCount {
                    if let page = document.page(at: UInt(pageIndex)) {
                        page.reloadAnnotations()
                        remainingRedactionCount += page.annotations.filter {
                            $0 is CPDFRedactAnnotation
                        }.count
                    }
                }
                guard redactionCount == 0 || remainingRedactionCount == 0 else {
                    result(FlutterError(
                        code: "APPLY_REDACTION_FAIL",
                        message: "Failed to apply all document redactions.",
                        details: nil
                    ))
                    return
                }
                self.pdfViewController?.pdfListView?.layoutDocumentView()
                result(nil)
            case CPDFConstants.updateWidget:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let properties = self.getValue(from: info, key: "data", defaultValue: [String:Any]())
                
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                pageUtil.updateWidget(pageIndex: pageIndex, uuid: uuid, properties: properties)
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                result(true)
                
            case CPDFConstants.addWidgetImageSignature:
                let info = call.arguments as? [String: Any]
                let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: 0)
                let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
                let imagePath = self.getValue(from: info, key: "image_path", defaultValue: "")
                
                let page = self.document?.page(at: UInt(pageIndex))
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = pageIndex
                pageUtil.addWidgetImageSignature(uuid: uuid, imagePath: URL(fileURLWithPath: imagePath)) { success in
                    if success {
                        self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                    }
                    result(success)
                }

            case CPDFConstants.writeSignature:
                self.writeSignature(call: call, result: result)
                
            case CPDFConstants.addAnnotations:
                let info = call.arguments as? [String: Any]
                let annotations = info?["annotations"] as? [[String: Any]] ?? []

                if let document = self.document {
                    let success = CPDFPageUtil.addAnnotations(document: document, annotations: annotations)
                    // Ask the view to refresh visible pages so newly added annotations will show when implemented.
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                    result(success)
                } else {
                    result(false)
                }
                
            case CPDFConstants.addWidgets:
                let info = call.arguments as? [String: Any]
                let widgetsDict = info?["widgets"] as? [[String: Any]] ?? []

                if let document = self.document {
                    let success = CPDFPageUtil.addWidgets(document: document, widgets: widgetsDict)
                    // Ask the view to refresh visible pages so newly added annotations will show when implemented.
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                    result(success)
                } else {
                    result(false)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        });
    }

    
    func getMemoryAddress<T: AnyObject>(_ object: T) -> String {
        let pointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: pointer)
    }

    private func getDigitalSignatures(result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            let signatures = self.digitalSignaturesMap()
            DispatchQueue.main.async {
                result(signatures)
            }
        }
    }

    private func digitalSignaturesMap() -> [[String: Any]] {
        guard let document = self.document else {
            return []
        }
        return document.signatures()?.enumerated().map { index, signature in
            // CPDFDocument.signatures() creates fresh CPDFSigner instances on
            // every call. Verify this instance before serializing its state.
            signature.verifySignature(with: document)
            return self.digitalSignatureMap(signature, document: document, signatureIndex: index)
        } ?? []
    }

    private func digitalSignatureMap(_ signature: CPDFSignature,
                                     document: CPDFDocument,
                                     signatureIndex: Int) -> [String: Any] {
        let permission = max(1, min(3, signature.permissions))
        let bounds = signature.bounds
        return [
            "signature_index": signatureIndex,
            "field_name": signature.fieldName ?? "",
            "page_index": Int(signature.pageIndex(with: document)),
            "bounds": [
                "left": bounds.minX,
                "top": bounds.maxY,
                "right": bounds.maxX,
                "bottom": bounds.minY
            ],
            "name": signature.name ?? "",
            "date": self.iso8601String(signature.date) ?? "",
            "reason": signature.reason ?? "",
            "location": signature.location ?? "",
            "filter": signature.filter ?? "",
            "sub_filter": signature.subFilter ?? "",
            "permissions": permission,
            "signers": (signature.signers ?? []).map { self.digitalSignerMap($0) },
            "modifications": (signature.modifyInfos ?? []).map {
                self.digitalModificationMap($0)
            }
        ]
    }

    private func digitalSignerMap(_ signer: CPDFSigner) -> [String: Any] {
        return [
            "signature_verified": signer.isSignVerified,
            "certificate_trusted": signer.isCertTrusted,
            "certificates": signer.certificates.map { self.digitalCertificateMap($0) }
        ]
    }

    private func digitalCertificateMap(_ certificate: CPDFSignatureCertificate) -> [String: Any] {
        let expired = Date() < certificate.validityStarts || Date() > certificate.validityEnds
        return [
            "version": certificate.version ?? "",
            "serial_number": certificate.serialNumber ?? "",
            // CPDFSignatureCertificate exposes the signature algorithm here,
            // not the certificate public-key type. Keep this field empty until
            // the iOS SDK exposes the same key type as Android.
            "key_type": "",
            "signature_algorithm": certificate.signatureAlgorithmOID ?? "",
            "issuer": certificate.issuer ?? "",
            "subject": certificate.subject ?? "",
            "valid_from": self.iso8601String(certificate.validityStarts) ?? "",
            "valid_to": self.iso8601String(certificate.validityEnds) ?? "",
            "sha1_digest": certificate.sha1Digest ?? "",
            "md5_digest": certificate.md5Digest ?? "",
            "is_trusted": certificate.isTrusted,
            "is_expired": expired
        ]
    }

    private func digitalModificationMap(_ modification: CPDFModifyInfo) -> [String: Any] {
        return [
            "type": String(modification.type.rawValue),
            "page_index": modification.pageIndex ?? -1,
            "annotation_type": modification.annotationType ?? -1,
            "form_type": modification.formType ?? -1,
            "info": modification.info ?? ""
        ]
    }

    private func verifyDigitalSignature(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let info = call.arguments as? [String: Any]
        let index = self.getValue(from: info, key: "signature_index", defaultValue: -1)
        guard index >= 0, let document = self.document,
              let signatures = document.signatures(), index < signatures.count else {
            result(FlutterError(code: "signature_verification_failed",
                                message: "The digital signature could not be found.",
                                details: nil))
            return
        }
        let signature = signatures[index]
        // Validation reads the saved file and may be slow; keep it off the UI thread.
        DispatchQueue.global(qos: .userInitiated).async {
            // This API updates CPDFSigner.isSignVerified and is required before
            // exposing signer metadata to Flutter.
            signature.verifySignature(with: document)
            let signers = signature.signers ?? []
            let trusted = signers.contains { $0.isCertTrusted }
            let expired = signers.flatMap { $0.certificates }.contains {
                Date() < $0.validityStarts || Date() > $0.validityEnds
            }
            let report = self.validationReport(for: signature, document: document)
            let value: [String: Any] = [
                "signature_valid": signature.verifySignature(document),
                "document_unmodified": signature.verifyDocument(document),
                "certificate_trusted": trusted,
                "certificate_expired": expired,
                "timestamp_trusted": signature.verifyTimestampAuthority(),
                "timestamp_source": signature.timestampSource.rawValue,
                "embedded_timestamp_valid": report.map { self.hasValidEmbeddedTimestamp($0) } as Any,
                "ltv_enabled": self.documentLtvReady(document)
            ]
            DispatchQueue.main.async {
                result(value)
            }
        }
    }

    private func getLtvReadiness(result: @escaping FlutterResult) {
        guard let document = self.document else {
            result(FlutterError(code: "invalid_document",
                                message: "The PDF document is not valid.",
                                details: nil))
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            // CPDFLtvService instances must not be shared across threads.
            let readiness = CPDFLtvService().assessReadiness(of: document)
            let value = self.ltvReadinessMap(readiness)
            DispatchQueue.main.async {
                result(value)
            }
        }
    }

    private func addSignatureLtv(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let info = call.arguments as? [String: Any]
        let outputPath = self.getValue(from: info, key: "output_path", defaultValue: "")
        let options = self.getValue(from: info, key: "options", defaultValue: [String: Any]())
        let trustedCertificatePath = self.getValue(from: options, key: "trusted_certificate_path", defaultValue: "")
        let appendDocumentTimestamp = self.getValue(from: options, key: "append_document_timestamp", defaultValue: false)
        let ltaOutputPath = self.getValue(from: options, key: "lta_output_path", defaultValue: "")
        let timestampServerUrl = self.getValue(from: options, key: "timestamp_server_url", defaultValue: "")

        guard !outputPath.isEmpty else {
            result(FlutterError(code: "ltv_output_invalid",
                                message: "The LTV output request is invalid.",
                                details: nil))
            return
        }
        guard FileManager.default.fileExists(atPath: trustedCertificatePath) else {
            result(FlutterError(code: "certificate_not_found",
                                message: "The trusted certificate file could not be found.",
                                details: nil))
            return
        }
        var tsaClient: CPDFURLSessionTSAClient?
        if appendDocumentTimestamp {
            guard !ltaOutputPath.isEmpty, let tsaURL = self.timestampServerURL(timestampServerUrl) else {
                result(FlutterError(code: "ltv_output_invalid",
                                    message: "A document timestamp needs a TSA URL and a separate output path.",
                                    details: nil))
                return
            }
            tsaClient = CPDFURLSessionTSAClient(url: tsaURL)
        }
        guard let inputURL = self.document?.documentURL,
              FileManager.default.fileExists(atPath: inputURL.path) else {
            result(FlutterError(code: "invalid_document",
                                message: "LTV material can only be added to a document saved as a file.",
                                details: nil))
            return
        }
        let inputPath = inputURL.path
        guard self.isValidOutput(outputPath, inputPath: inputPath),
              !appendDocumentTimestamp
                || (self.isValidOutput(ltaOutputPath, inputPath: inputPath)
                    && !self.isSamePath(outputPath, ltaOutputPath)) else {
            result(FlutterError(code: "ltv_output_invalid",
                                message: "The LTV output path must be a new file in an existing directory.",
                                details: nil))
            return
        }

        let prolongOptions = CPDFPadesProlongOptions()
        prolongOptions.trustedCertPath = trustedCertificatePath
        let ocspUrls = self.getValue(from: options, key: "ocsp_urls", defaultValue: [String]())
        let crlUrls = self.getValue(from: options, key: "crl_urls", defaultValue: [String]())
        prolongOptions.ocspURLs = ocspUrls.isEmpty ? nil : ocspUrls
        prolongOptions.crlURLs = crlUrls.isEmpty ? nil : crlUrls
        // The iOS default is YES; always set it so both platforms behave the same.
        prolongOptions.appendDocumentTimestamp = appendDocumentTimestamp
        prolongOptions.ltaTSAClient = tsaClient

        DispatchQueue.global(qos: .userInitiated).async {
            let prolongResult = CPDFPadesSigner().prolongLTV(fromPath: inputPath,
                                                             ltvPath: outputPath,
                                                             ltaPath: appendDocumentTimestamp ? ltaOutputPath : nil,
                                                             options: prolongOptions)
            let success = prolongResult.success
            // A failed run can still echo the requested paths, so only report
            // paths for a successful run.
            let value: [String: Any] = [
                "success": success,
                "ltv_path": success ? prolongResult.ltvPath : "",
                "lta_path": success ? prolongResult.ltaPath : "",
                "errors": prolongResult.errors.map { self.signatureIssueMap($0) },
                "warnings": prolongResult.warnings.map { self.signatureIssueMap($0) }
            ]
            DispatchQueue.main.async {
                result(value)
            }
        }
    }

    private func validationReport(for signature: CPDFSignature,
                                  document: CPDFDocument) -> CPDFSignatureValidationReport? {
        let options = CPDFSignatureWorkflowValidationOptions()
        options.fieldName = signature.fieldName
        let validation = CPDFSignatureWorkflow(document: document).validateDocument(with: options)
        return validation.reports.first { $0.fieldName == signature.fieldName }
    }

    /// Mirrors Android `CPDFSignatureValidationReport.hasEmbeddedTimestamp()`.
    private func hasValidEmbeddedTimestamp(_ report: CPDFSignatureValidationReport) -> Bool {
        return report.items.contains {
            $0.code.hasPrefix("timestamp.embedded.") && $0.status == .valid
        }
    }

    /// Matches the document-level LTV check used by the Android ComPDFKit_Tools demo.
    private func documentLtvReady(_ document: CPDFDocument) -> Bool {
        let readiness = CPDFLtvService().assessReadiness(of: document)
        return readiness.success && readiness.readinessInfo.ltvReady
    }

    private func ltvReadinessMap(_ readiness: CPDFLtvReadinessResult) -> [String: Any] {
        let info = readiness.readinessInfo
        let dssInfo = info.dssInfo
        return [
            "success": readiness.success,
            "has_dss": info.hasDSS,
            "has_vri": info.hasVRI,
            "has_certificates": info.hasCertificates,
            "has_revocation": info.hasRevocation,
            "ltv_ready": info.ltvReady,
            "profile_hint": info.profileHint,
            "missing_materials": info.missingMaterials.filter { !$0.isEmpty },
            "dss": [
                "certificates_count": dssInfo.certificatesCount,
                "ocsp_responses_count": dssInfo.ocspResponsesCount,
                "crls_count": dssInfo.crlsCount,
                "vri_entries_count": dssInfo.vriEntriesCount
            ],
            "errors": readiness.errors.map { self.signatureIssueMap($0) },
            "warnings": readiness.warnings.map { self.signatureIssueMap($0) }
        ]
    }

    private func signatureIssueMap(_ item: CPDFValidationReportItem) -> [String: Any] {
        return [
            "code": item.code,
            "message": item.message
        ]
    }

    private func timestampServerURL(_ value: String) -> URL? {
        guard let url = URL(string: value),
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https",
              url.host?.isEmpty == false else {
            return nil
        }
        return url
    }

    private func isValidOutput(_ outputPath: String, inputPath: String) -> Bool {
        guard !outputPath.isEmpty else {
            return false
        }
        var isDirectory: ObjCBool = false
        let parent = (outputPath as NSString).deletingLastPathComponent
        return FileManager.default.fileExists(atPath: parent, isDirectory: &isDirectory)
            && isDirectory.boolValue
            && !self.isSamePath(outputPath, inputPath)
    }

    private func isSamePath(_ first: String, _ second: String) -> Bool {
        return URL(fileURLWithPath: first).standardizedFileURL.resolvingSymlinksInPath()
            == URL(fileURLWithPath: second).standardizedFileURL.resolvingSymlinksInPath()
    }

    private func writeSignature(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let info = call.arguments as? [String: Any]
        let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: -1)
        let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
        let outputPath = self.getValue(from: info, key: "output_path", defaultValue: "")
        let config = self.getValue(from: info, key: "config", defaultValue: [String: Any]())
        let certificatePath = self.getValue(from: config, key: "certificate_path", defaultValue: "")
        let password = self.getValue(from: config, key: "password", defaultValue: "")

        guard pageIndex >= 0, !uuid.isEmpty else {
            result(FlutterError(code: "signature_widget_not_found",
                                message: "The signature form field could not be found.",
                                details: nil))
            return
        }
        guard !outputPath.isEmpty, !certificatePath.isEmpty,
              FileManager.default.fileExists(atPath: certificatePath) else {
            result(FlutterError(code: "certificate_not_found",
                                message: "The signing certificate could not be found.",
                                details: nil))
            return
        }
        guard !password.isEmpty, let document = self.document,
              let sourceURL = document.documentURL else {
            result(FlutterError(code: "invalid_certificate_password",
                                message: "The certificate password is invalid.",
                                details: nil))
            return
        }
        let outputURL = URL(fileURLWithPath: outputPath)
        if outputURL.standardizedFileURL == sourceURL.standardizedFileURL {
            result(FlutterError(code: "invalid_document",
                                message: "The signed PDF must be written to a new file.",
                                details: nil))
            return
        }
        guard let page = document.page(at: UInt(pageIndex)),
              let widget = page.annotations.compactMap({ $0 as? CPDFSignatureWidgetAnnotation })
                .first(where: { CPDFUtil.getMemoryAddress($0) == uuid }) else {
            result(FlutterError(code: "signature_widget_not_found",
                                message: "The signature form field could not be found.",
                                details: nil))
            return
        }
        let appearance = self.getValue(from: config, key: "appearance", defaultValue: [String: Any]())
        let signatureConfig = CPDFSignatureConfig()
        signatureConfig.isDrawKey = true
        let appearanceText = self.getValue(from: appearance, key: "text", defaultValue: "")
        signatureConfig.text = appearanceText.isEmpty
            ? self.getValue(from: config, key: "name", defaultValue: "")
            : appearanceText
        signatureConfig.isDrawLogo = self.getValue(from: appearance, key: "draw_logo", defaultValue: true)
        signatureConfig.isDrawOnlyContent = self.getValue(from: appearance, key: "draw_only_content", defaultValue: false)
        signatureConfig.isContentAlginLeft = self.getValue(from: appearance, key: "content_align_left", defaultValue: true)
        let textColor = self.getValue(from: appearance, key: "text_color", defaultValue: "#FF000000")
        let contentColor = self.getValue(from: appearance, key: "content_color", defaultValue: "#FF000000")
        signatureConfig.textColor = ColorHelper.colorWithHexString(hex: textColor)
        signatureConfig.contentsColor = ColorHelper.colorWithHexString(hex: contentColor)
        let appearanceContent = self.getValue(from: appearance, key: "content", defaultValue: "")
        if !appearanceContent.isEmpty {
            var contentItems: [CPDFSignatureConfigItem] = []
            for line in appearanceContent.components(separatedBy: .newlines) where !line.isEmpty {
                let parts = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
                let item = CPDFSignatureConfigItem()
                item.key = ""
                item.value = ""
                if parts.count == 2 {
                    item.key = String(parts[0]).trimmingCharacters(in: .whitespaces)
                    item.value = String(parts[1]).trimmingCharacters(in: .whitespaces)
                } else {
                    item.value = line
                }
                contentItems.append(item)
            }
            signatureConfig.contents = contentItems
        }
        if let imagePath = appearance["image_path"] as? String, !imagePath.isEmpty {
            guard let image = UIImage(contentsOfFile: imagePath) else {
                result(FlutterError(code: "invalid_document",
                                    message: "The signature appearance image is invalid.",
                                    details: nil))
                return
            }
            signatureConfig.image = image
        }
        if let logoPath = appearance["logo_path"] as? String, !logoPath.isEmpty {
            guard let logo = UIImage(contentsOfFile: logoPath) else {
                result(FlutterError(code: "invalid_document",
                                    message: "The signature logo image is invalid.",
                                    details: nil))
                return
            }
            signatureConfig.logo = logo
        }
        widget.signAppearanceConfig(signatureConfig)
        let rawPermission = self.getValue(from: config, key: "permissions", defaultValue: 2)
        let permission = CPDFSignaturePermissions(rawValue: max(1, min(3, rawPermission))) ?? .fillSign
        let location = self.getValue(from: config, key: "location", defaultValue: "")
        let reason = self.getValue(from: config, key: "reason", defaultValue: "")
        let timestampServerUrl = config["timestamp_server_url"] as? String
        var tsaClient: CPDFURLSessionTSAClient?
        if let timestampServerUrl = timestampServerUrl {
            guard let tsaURL = self.timestampServerURL(timestampServerUrl) else {
                result(FlutterError(code: "signature_timestamp_failed",
                                    message: "The timestamp server URL is invalid.",
                                    details: nil))
                return
            }
            tsaClient = CPDFURLSessionTSAClient(url: tsaURL)
        }

        // PDF signing can be expensive, and the TSA client is called back
        // synchronously on the framework queue. Keep it off the Flutter/UI
        // thread and deliver the MethodChannel result on the main thread.
        DispatchQueue.global(qos: .userInitiated).async {
            let success = document.writeSignature(to: outputURL,
                                                   withWidget: widget,
                                                   pkcs12Cert: certificatePath,
                                                   password: password,
                                                   location: location,
                                                   reason: reason,
                                                   isSetSignAp: false,
                                                   permissions: permission,
                                                   tsaClient: tsaClient)
            DispatchQueue.main.async {
                if !success && tsaClient != nil {
                    // The native call only reports a boolean. With a TSA the most
                    // likely cause is an unreachable or rejecting timestamp server.
                    result(FlutterError(code: "signature_timestamp_failed",
                                        message: "The digital signature could not be written with the requested timestamp. The TSA may be unreachable or rejected the request.",
                                        details: nil))
                } else {
                    result(success)
                }
            }
        }
    }

    private func iso8601String(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        return ISO8601DateFormatter().string(from: date)
    }
    
    private func getWatermark(call: FlutterMethodCall, result: FlutterResult) {
        guard let watermark = self.watermark(from: call) else {
            result(nil)
            return
        }
        let info = call.arguments as? [String: Any]
        let exportImage: Bool = self.getValue(from: info, key: "export_image", defaultValue: false)
        let watermarkInfo = self.toWatermarkMap(
            watermark,
            index: self.watermarkIndex(from: call),
            exportImage: exportImage
        )
        self.debugPrintWatermarkData("getWatermark result", data: watermarkInfo)
        result(watermarkInfo)
    }

    private func updateWatermark(call: FlutterMethodCall, result: FlutterResult) {
        guard let watermark = self.watermark(from: call) else {
            result(false)
            return
        }
        let info = call.arguments as? [String: Any]
        let requestedType: String = self.getValue(from: info, key: "type", defaultValue: "")
        if !requestedType.isEmpty && requestedType != self.watermarkTypeName(watermark.type) {
            result(false)
            return
        }
        if let validationError = self.validateWatermarkInfo(info, watermark: watermark) {
            result(FlutterError(code: "WATERMARK_FAIL", message: validationError, details: nil))
            return
        }
        guard self.applyWatermarkInfo(info, to: watermark, result: result) else {
            return
        }
        let success = self.document?.updateWatermark(watermark) ?? false
        if success {
            self.pdfViewController?.pdfListView?.layoutDocumentView()
        }
        result(success)
    }

    private func removeWatermark(call: FlutterMethodCall, result: FlutterResult) {
        guard let watermark = self.watermark(from: call) else {
            result(false)
            return
        }
        let success = self.document?.removeWatermark(watermark) ?? false
        if success {
            self.pdfViewController?.pdfListView?.layoutDocumentView()
        }
        result(success)
    }

    private func watermark(from call: FlutterMethodCall) -> CPDFWatermark? {
        let index = self.watermarkIndex(from: call)
        let watermarks = self.document?.watermarks() ?? []
        guard index >= 0 && index < watermarks.count else {
            return nil
        }
        return watermarks[index]
    }

    private func watermarkIndex(from call: FlutterMethodCall) -> Int {
        let info = call.arguments as? [String: Any]
        return self.getValue(from: info, key: "index", defaultValue: -1)
    }

    private func toWatermarkMap(_ watermark: CPDFWatermark, index: Int, exportImage: Bool) -> [String: Any] {
        let exportedImage = self.exportWatermarkImage(watermark, index: index, exportImage: exportImage)
        return [
            "index": index,
            "type": self.watermarkTypeName(watermark.type),
            "text_content": watermark.text ?? "",
            "image_path": exportedImage.path,
            "is_image_exported": exportedImage.exported,
            "text_color": self.hexString(from: watermark.textColor),
            "font_size": watermark.fontSize,
            "scale": watermark.scale,
            "rotation": watermark.rotation,
            "opacity": watermark.opacity,
            "vertical_alignment": self.verticalAlignmentName(watermark.verticalPosition),
            "horizontal_alignment": self.horizontalAlignmentName(watermark.horizontalPosition),
            "vertical_offset": watermark.ty,
            "horizontal_offset": watermark.tx,
            "pages": watermark.pageString ?? "",
            "is_front": watermark.isFront,
            "is_tile_page": watermark.isTilePage,
            "horizontal_spacing": watermark.horizontalSpacing,
            "vertical_spacing": watermark.verticalSpacing,
        ]
    }

    private func debugPrintWatermarkData(_ label: String, data: [String: Any]) {
        guard JSONSerialization.isValidJSONObject(data),
              let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted]),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("ComPDFKit-Flutter: \(label): \(data)")
            return
        }
        print("ComPDFKit-Flutter: \(label):\\n\(jsonString)")
    }

    private func exportWatermarkImage(
        _ watermark: CPDFWatermark,
        index: Int,
        exportImage: Bool
    ) -> (path: String, exported: Bool) {
        guard exportImage, watermark.type == .image, let image = watermark.image,
              let imageData = image.pngData() else {
            return ("", false)
        }
        let documentKey = abs((self.document?.documentURL?.path ?? "document").hashValue)
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("compdfkit")
            .appendingPathComponent("watermarks")
            .appendingPathComponent("\(documentKey)")
        do {
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true,
                attributes: nil
            )
            let fileName = "watermark_\(index)_\(Int(Date().timeIntervalSince1970 * 1000))_\(UUID().uuidString).png"
            let fileURL = directory.appendingPathComponent(fileName)
            try imageData.write(to: fileURL, options: .atomic)
            return (fileURL.path, true)
        } catch {
            NSLog("ComPDFKit-Flutter: Failed to export watermark image: \(error.localizedDescription)")
            return ("", false)
        }
    }

    private func validateWatermarkInfo(
        _ info: [String: Any]?,
        watermark: CPDFWatermark
    ) -> String? {
        let pages: String = self.getValue(from: info, key: "pages", defaultValue: "")
        if pages.isEmpty {
            return "The page range cannot be empty, please set the page range, for example: pages: \"0,1,2,3\""
        }

        if watermark.type == .text {
            let textContent: String = self.getValue(from: info, key: "text_content", defaultValue: "")
            if textContent.isEmpty {
                return "Add text watermark, the text cannot be empty"
            }
        } else if watermark.type == .image {
            let imagePath: String = self.getValue(from: info, key: "image_path", defaultValue: "")
            if imagePath.isEmpty && watermark.image == nil {
                return "image path is empty"
            }
        }

        return nil
    }

    private func applyWatermarkInfo(
        _ info: [String: Any]?,
        to watermark: CPDFWatermark,
        result: FlutterResult
    ) -> Bool {
        let pages: String = self.getValue(from: info, key: "pages", defaultValue: "")
        let textContent: String = self.getValue(from: info, key: "text_content", defaultValue: "")
        let imagePath: String = self.getValue(from: info, key: "image_path", defaultValue: "")
        let textColor: String = self.getValue(from: info, key: "text_color", defaultValue: "#000000")
        let fontSize: Int = self.getValue(from: info, key: "font_size", defaultValue: 30)
        let scale: Double = self.getValue(from: info, key: "scale", defaultValue: 1.0)
        let rotation: Double = self.getValue(from: info, key: "rotation", defaultValue: 45.0)
        let opacity: Double = self.getValue(from: info, key: "opacity", defaultValue: 1.0)
        let verticalAlignment: String = self.getValue(
            from: info,
            key: "vertical_alignment",
            defaultValue: "center"
        )
        let horizontalAlignment: String = self.getValue(
            from: info,
            key: "horizontal_alignment",
            defaultValue: "center"
        )
        let verticalOffset: Double = self.getValue(from: info, key: "vertical_offset", defaultValue: 0.0)
        let horizontalOffset: Double = self.getValue(from: info, key: "horizontal_offset", defaultValue: 0.0)
        let isFront: Bool = self.getValue(from: info, key: "is_front", defaultValue: true)
        let isTilePage: Bool = self.getValue(from: info, key: "is_tile_page", defaultValue: false)
        let horizontalSpacing: Double = self.getValue(from: info, key: "horizontal_spacing", defaultValue: 0.0)
        let verticalSpacing: Double = self.getValue(from: info, key: "vertical_spacing", defaultValue: 0.0)

        if watermark.type == .text {
            watermark.text = textContent
            watermark.fontSize = CGFloat(fontSize)
            watermark.textColor = ColorHelper.colorWithHexString(hex: textColor)
        } else if watermark.type == .image {
            if !imagePath.isEmpty {
                guard let image = UIImage(contentsOfFile: imagePath) else {
                    result(FlutterError(code: "WATERMARK_FAIL", message: "image path is invalid", details: nil))
                    return false
                }
                watermark.image = image
            }
        }
        watermark.opacity = opacity
        watermark.scale = scale
        watermark.isTilePage = isTilePage
        watermark.isFront = isFront
        watermark.tx = horizontalOffset
        watermark.ty = verticalOffset
        watermark.rotation = rotation
        watermark.pageString = pages
        watermark.horizontalPosition = self.watermarkHorizontalPosition(horizontalAlignment)
        watermark.verticalPosition = self.watermarkVerticalPosition(verticalAlignment)
        if isTilePage {
            watermark.verticalSpacing = verticalSpacing
            watermark.horizontalSpacing = horizontalSpacing
        }
        return true
    }

    private func watermarkTypeName(_ type: CPDFWatermarkType) -> String {
        return type == .image ? "image" : "text"
    }

    private func watermarkVerticalPosition(_ value: String) -> CPDFWatermarkVerticalPosition {
        if value == "top" {
            return .top
        }
        if value == "bottom" {
            return .bottom
        }
        return .center
    }

    private func watermarkHorizontalPosition(_ value: String) -> CPDFWatermarkHorizontalPosition {
        if value == "left" {
            return .left
        }
        if value == "right" {
            return .right
        }
        return .center
    }

    private func verticalAlignmentName(_ position: CPDFWatermarkVerticalPosition) -> String {
        switch position {
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        default:
            return "center"
        }
    }

    private func horizontalAlignmentName(_ position: CPDFWatermarkHorizontalPosition) -> String {
        switch position {
        case .left:
            return "left"
        case .right:
            return "right"
        default:
            return "center"
        }
    }

    private func hexString(from color: UIColor?) -> String {
        guard let color = color else {
            return "#000000"
        }
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(
            format: "#%02X%02X%02X%02X",
            Int(alpha * 255),
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255)
        )
    }

    private func createWatermark(call: FlutterMethodCall, result: FlutterResult) {
        guard let document = self.document else {
            result(false)
            return
        }
        let info = call.arguments as? [String: Any]
        // text, image
        let type : String = self.getValue(from: info, key: "type", defaultValue: "")
        // "0,1,2,3,4"
        let pages : String = self.getValue(from: info, key: "pages", defaultValue: "")
        
        let textContent : String = self.getValue(from: info, key: "text_content", defaultValue: "")
        
        let imagePath : String = self.getValue(from: info, key: "image_path", defaultValue: "")
        let textColor : String = self.getValue(from: info, key: "text_color", defaultValue: "#000000")
        let fontSize : Int = self.getValue(from: info, key: "font_size", defaultValue: 24)
        let scale : Double = self.getValue(from: info, key: "scale", defaultValue: 1.0)
        let rotation : Double = self.getValue(from: info, key: "rotation", defaultValue: 45)
        let opacity : Double = self.getValue(from: info, key: "opacity", defaultValue: 1.0)
        // top, center, bottom
        let verticalAlignment : String = self.getValue(from: info, key: "vertical_alignment", defaultValue: "center")
        // left, center, right
        let horizontalAlignment : String = self.getValue(from: info, key: "horizontal_alignment", defaultValue: "center")
        let verticalOffset : Double = self.getValue(from: info, key: "vertical_offset", defaultValue: 0)
        let horizontalOffset : Double = self.getValue(from: info, key: "horizontal_offset", defaultValue: 0)
        let isFront : Bool = self.getValue(from: info, key: "is_front", defaultValue: true)
        let isTilePage : Bool = self.getValue(from: info, key: "is_tile_page", defaultValue: false)
        let horizontalSpacing : Double = self.getValue(from: info, key: "horizontal_spacing", defaultValue: 0)
        let verticalSpacing : Double = self.getValue(from: info, key: "vertical_spacing", defaultValue: 0)
        
        var vertical:CPDFWatermarkVerticalPosition = .center
        var horizontal:CPDFWatermarkHorizontalPosition = .center
        
        switch verticalAlignment {
        case "top":
            vertical = .top
        case "center":
            vertical = .center
        case "bottom":
            vertical = .bottom
        default:
            vertical = .center
        }
        
        switch horizontalAlignment {
        case "left":
            horizontal = .left
        case "center":
            horizontal = .center
        case "right":
            horizontal = .right
        default:
            horizontal = .center
        }
        print("createWatermark: Pages: \(pages)")
        if(pages.isEmpty){
            result(FlutterError(code: "WATERMARK_FAIL", message: "The page range cannot be empty, please set the page range, for example: pages: \"0,1,2,3\"", details: nil))
            return
        }
        
        if("text" == type){
            if(textContent.isEmpty){
                result(FlutterError(code: "WATERMARK_FAIL", message: "Add text watermark, the text cannot be empty", details: nil))
                return
            }
        } else{
            if(imagePath.isEmpty){
                result(FlutterError(code: "WATERMARK_FAIL", message: "image path is empty", details: nil))
                return
            }
        }
        
        if type == "text" {
            guard let textWatermark = CPDFWatermark(document: document, type: .text) else {
                result(false)
                return
            }
            
            textWatermark.text = textContent
            let font = CPDFFont(familyName: "Helvetica", fontStyle: "")
            textWatermark.cFont = font
            textWatermark.opacity = opacity
            textWatermark.fontSize = CGFloat(fontSize)
            textWatermark.textColor = ColorHelper.colorWithHexString(hex: textColor)
            textWatermark.scale = scale
            textWatermark.isTilePage = isTilePage
            textWatermark.isFront = isFront
            textWatermark.tx = horizontalOffset
            textWatermark.ty = verticalOffset
            textWatermark.rotation = rotation
            textWatermark.pageString = pages
            textWatermark.horizontalPosition = horizontal
            textWatermark.verticalPosition = vertical
            
            if textWatermark.isTilePage {
                textWatermark.verticalSpacing = verticalSpacing
                textWatermark.horizontalSpacing = horizontalSpacing
            }
            
            document.addWatermark(textWatermark)
        } else if type == "image" {
            guard let image = UIImage(contentsOfFile: imagePath) else {
                result(FlutterError(code: "WATERMARK_FAIL", message: "image path is invalid", details: nil))
                return
            }
            guard let imageWatermark = CPDFWatermark(document: document, type: .image) else {
                result(false)
                return
            }
            
            imageWatermark.image = image
            imageWatermark.opacity = opacity
            imageWatermark.scale = scale
            imageWatermark.isTilePage = isTilePage
            imageWatermark.isFront = isFront
            imageWatermark.tx = horizontalOffset
            imageWatermark.ty = verticalOffset

            imageWatermark.rotation = rotation
            imageWatermark.pageString = pages
            imageWatermark.horizontalPosition = horizontal
            imageWatermark.verticalPosition = vertical
            
            if imageWatermark.isTilePage {
                imageWatermark.verticalSpacing = verticalSpacing
                imageWatermark.horizontalSpacing = horizontalSpacing
            }
            
            document.addWatermark(imageWatermark)
        } else {
            result(FlutterError(code: "WATERMARK_FAIL", message: "Invalid watermark type", details: nil))
            return
        }
        
        self.pdfViewController?.pdfListView?.layoutDocumentView()
        result(true)
    }
    
    func getValue<T>(from info: [String: Any]?, key: String, defaultValue: T) -> T {
        guard let value = info?[key] as? T else {
            return defaultValue
        }
        return value
    }

    private func extractImages(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let info = call.arguments as? [String: Any]
        let directoryPath = self.getValue(from: info, key: "directory_path", defaultValue: "")

        guard !directoryPath.isEmpty else {
            result(FlutterError(
                code: "EXTRACT_IMAGES_FAIL",
                message: "directory_path is empty",
                details: nil))
            return
        }

        guard let document = self.document else {
            result(FlutterError(
                code: "EXTRACT_IMAGES_FAIL",
                message: "document is nil",
                details: nil))
            return
        }

        let pages = self.getValue(from: info, key: "pages", defaultValue: [Int]())
        guard let indexSet = self.extractImageIndexSet(
            pages: pages,
            pageCount: Int(document.pageCount),
            result: result
        ) else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: directoryPath) {
                    var isDirectory: ObjCBool = false
                    fileManager.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
                    if !isDirectory.boolValue {
                        DispatchQueue.main.async {
                            result(FlutterError(
                                code: "EXTRACT_IMAGES_FAIL",
                                message: "directory_path is not a directory: \(directoryPath)",
                                details: nil))
                        }
                        return
                    }
                } else {
                    try fileManager.createDirectory(
                        atPath: directoryPath,
                        withIntermediateDirectories: true,
                        attributes: nil)
                }

                _ = document.extractImage(fromPages: indexSet, toPath: directoryPath)
                let imagePaths = self.filePaths(in: directoryPath)
                let resultMap: [String: Any] = [
                    "success": true,
                    "count": imagePaths.count,
                    "directory_path": directoryPath,
                    "image_paths": imagePaths
                ]

                DispatchQueue.main.async {
                    result(resultMap)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "EXTRACT_IMAGES_FAIL",
                        message: error.localizedDescription,
                        details: nil))
                }
            }
        }
    }

    private func extractImageIndexSet(
        pages: [Int],
        pageCount: Int,
        result: @escaping FlutterResult
    ) -> IndexSet? {
        if pages.isEmpty {
            return IndexSet(integersIn: 0..<pageCount)
        }

        var indexSet = IndexSet()
        for page in pages {
            guard page >= 0 && page < pageCount else {
                result(FlutterError(
                    code: "EXTRACT_IMAGES_FAIL",
                    message: "Invalid page index: \(page)",
                    details: nil))
                return nil
            }
            indexSet.insert(page)
        }
        return indexSet
    }

    private func filePaths(in directoryPath: String) -> [String] {
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: directoryPath) else {
            return []
        }

        return fileNames.compactMap { fileName in
            let path = (directoryPath as NSString).appendingPathComponent(fileName)
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory),
               !isDirectory.boolValue {
                return path
            }
            return nil
        }.sorted()
    }

    private func validatedPageIndex(
        from info: [String: Any]?,
        errorCode: String,
        result: @escaping FlutterResult
    ) -> Int? {
        guard let document = self.document else {
            result(FlutterError(
                code: errorCode,
                message: "document is nil",
                details: nil))
            return nil
        }

        let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: -1)
        guard pageIndex >= 0 && pageIndex < document.pageCount else {
            result(FlutterError(
                code: errorCode,
                message: "Invalid page index: \(pageIndex)",
                details: nil))
            return nil
        }

        return pageIndex
    }

    private func headerFooterMap() -> [String: Any]? {
        guard let headerFooter = self.document?.headerFooter() else {
            return nil
        }
        let hasContent = (0..<6).contains { index in
            !(headerFooter.text(at: UInt(index)) ?? "").isEmpty
        }
        guard hasContent else {
            return nil
        }
        let margin = headerFooter.margin
        var slots: [[String: Any]] = []
        for index in 0..<6 {
            slots.append([
                "position": self.headerFooterPosition(index),
                "text": headerFooter.text(at: UInt(index)) ?? "",
                "font_name": headerFooter.fontName(at: UInt(index)) ?? "Helvetica",
                "font_size": Double(headerFooter.fontSize(at: UInt(index))),
                "text_color": headerFooter.textColor(at: UInt(index))?.toHexString() ?? "#000000"
            ])
        }
        return [
            "pages": headerFooter.pageString ?? "",
            "margin": [
                "left": Double(margin.left),
                "top": Double(margin.top),
                "right": Double(margin.right),
                "bottom": Double(margin.bottom)
            ],
            "slots": slots
        ]
    }

    private func updateHeaderFooter(call: FlutterMethodCall, result: FlutterResult) {
        guard let headerFooter = self.document?.headerFooter(),
              let info = call.arguments as? [String: Any],
              let pages = info["pages"] as? String,
              !pages.isEmpty,
              let margin = info["margin"] as? [String: Any],
              let slots = info["slots"] as? [[String: Any]],
              !slots.isEmpty,
              let left = self.headerFooterNumber(margin["left"]),
              let top = self.headerFooterNumber(margin["top"]),
              let right = self.headerFooterNumber(margin["right"]),
              let bottom = self.headerFooterNumber(margin["bottom"]) else {
            result(FlutterError(
                code: "HEADER_FOOTER_FAIL",
                message: "Header/footer payload is invalid.",
                details: nil))
            return
        }

        var positions = Set<Int>()
        for slot in slots {
            guard let position = slot["position"] as? String,
                  let index = self.headerFooterIndex(position),
                  positions.insert(index).inserted,
                  let fontSize = self.headerFooterNumber(slot["font_size"]),
                  fontSize > 0 else {
                result(FlutterError(
                    code: "HEADER_FOOTER_FAIL",
                    message: "Header/footer slot is invalid.",
                    details: nil))
                return
            }
        }

        headerFooter.pageString = pages
        headerFooter.margin = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        for index in 0..<6 {
            headerFooter.setText("", at: UInt(index))
        }
        for slot in slots {
            guard let position = slot["position"] as? String,
                  let index = self.headerFooterIndex(position),
                  let fontSize = self.headerFooterNumber(slot["font_size"]) else {
                continue
            }
            headerFooter.setText(slot["text"] as? String ?? "", at: UInt(index))
            headerFooter.setFontName(slot["font_name"] as? String ?? "Helvetica", at: UInt(index))
            headerFooter.setFontSize(fontSize, at: UInt(index))
            headerFooter.setTextColor(
                ColorHelper.colorWithHexString(hex: slot["text_color"] as? String ?? "#FF000000"),
                at: UInt(index))
        }
        headerFooter.update()
        self.pdfViewController?.pdfListView?.layoutDocumentView()
        result(true)
    }

    /// Writes the document converted to a PDF standard into a new file.
    ///
    /// Unlike Android, the iOS SDK converts a copy of the in-memory document and leaves the opened
    /// document untouched, so no reload is needed afterwards. The SDK deletes an existing file at
    /// the output path before writing it, which is why the output path is checked against the
    /// current document before anything runs.
    private func convertToPdfStandard(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let document = self.document else {
            result(FlutterError(code: "DOCUMENT_INVALID", message: "The document is released or invalid.", details: nil))
            return
        }
        let info = call.arguments as? [String: Any]
        let outputPath = self.getValue(from: info, key: "output_path", defaultValue: "")
        let type = self.getValue(from: info, key: "type", defaultValue: "")
        let fontSubset = self.getValue(from: info, key: "font_subset", defaultValue: true)

        if CPDFPdfStandardUtil.unsupportedTargets.contains(type) {
            result(FlutterError(
                code: "UNSUPPORTED_PDF_STANDARD",
                message: "\(type) is not supported on iOS.",
                details: nil))
            return
        }
        guard let mode = CPDFPdfStandardUtil.mode(from: type) else {
            result(FlutterError(
                code: "PDF_STANDARD_CONVERT_FAILED",
                message: "Unknown PDF standard type: \(type)",
                details: nil))
            return
        }

        let savePath: String
        switch self.validatePdfStandardOutputPath(outputPath, document: document) {
        case .success(let path):
            savePath = path
        case .failure(let error):
            result(FlutterError(code: "INVALID_OUTPUT_PATH", message: error.message, details: nil))
            return
        }

        // The iOS core would strip the security and convert anyway; Android refuses a document
        // opened with a password, so do the same here to keep one behavior across platforms.
        if document.isEncrypted && !(document.password ?? "").isEmpty {
            result(FlutterError(
                code: "ENCRYPTED_DOCUMENT_NOT_CONVERTIBLE",
                message: "An encrypted document cannot be converted. Remove the password with saveAs first.",
                details: nil))
            return
        }

        // The conversion starts from the in-memory document, so pending ink and content edits
        // have to be committed on the main thread first or they are missing from the output.
        if let pdfListView = self.pdfViewController?.pdfListView {
            pdfListView.exitDrawing()
            if pdfListView.isEditing() && pdfListView.isEdited() {
                pdfListView.commitEditing()
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            var flutterError: FlutterError?
            do {
                // The SDK also ships a Bool-returning overload with the same selector prefix, so
                // Swift imports this NSError variant with a placeholder `error: ()` argument.
                try document.writeStandardPDF(
                    toFilePath: savePath,
                    withType: mode,
                    iccFilePath: nil,
                    with: nil,
                    isSaveFontSubset: fontSubset,
                    error: ())
                if !FileManager.default.fileExists(atPath: savePath) {
                    flutterError = FlutterError(
                        code: "PDF_STANDARD_SAVE_FAILED",
                        message: "The conversion succeeded but writing \(savePath) failed.",
                        details: nil)
                }
            } catch let error as NSError {
                flutterError = self.pdfStandardError(error, type: type)
            }
            DispatchQueue.main.async {
                result(flutterError ?? true)
            }
        }
    }

    struct PdfStandardPathError: Error {
        let message: String
    }

    /// Mirrors Android `DocumentStandardOps.validateOutputPath`. Returns the plain file path to
    /// write to; a `file://` URL is accepted as well. Also used by `CPDFDocumentOptimizeOps`.
    func validatePdfStandardOutputPath(
        _ outputPath: String,
        document: CPDFDocument
    ) -> Result<String, PdfStandardPathError> {
        let trimmed = outputPath.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return .failure(PdfStandardPathError(message: "output_path must not be empty."))
        }
        let path: String
        if let url = URL(string: trimmed), url.isFileURL {
            path = url.path
        } else {
            path = trimmed
        }
        let outputURL = URL(fileURLWithPath: path)
        let parent = outputURL.deletingLastPathComponent().path
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: parent, isDirectory: &isDirectory) || !isDirectory.boolValue {
            return .failure(PdfStandardPathError(message: "The parent directory of \(path) does not exist."))
        }
        if !FileManager.default.isWritableFile(atPath: parent) {
            return .failure(PdfStandardPathError(message: "The directory \(parent) is not writable."))
        }
        // The sandbox exposes the same location as /var and /private/var, so compare the
        // resolved paths rather than the raw strings.
        if let documentURL = document.documentURL,
           documentURL.standardizedFileURL.resolvingSymlinksInPath().path
            == outputURL.standardizedFileURL.resolvingSymlinksInPath().path {
            return .failure(PdfStandardPathError(message: "output_path must differ from the path of the current document."))
        }
        return .success(path)
    }

    private func pdfStandardError(_ error: NSError, type: String) -> FlutterError {
        let details: [String: Any] = ["native_domain": error.domain, "native_code": error.code]
        let reason = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String ?? ""
        if error.domain == CPDFStandardConversionErrorDomain
            && error.code == CPDFStandardConversionError.Code.unsupportedFormat.rawValue {
            return FlutterError(
                code: "UNSUPPORTED_PDF_STANDARD",
                message: "\(type) is not supported on iOS.",
                details: details)
        }
        var message = "The conversion to \(type) failed (native code \(error.code))."
        if !reason.isEmpty {
            message += " \(reason)"
        }
        return FlutterError(code: "PDF_STANDARD_CONVERT_FAILED", message: message, details: details)
    }

    private func batesMap() -> [String: Any]? {
        guard let bates = self.document?.bates() else { return nil }
        let hasContent = (0..<6).contains { index in
            !(bates.text(at: UInt(index)) ?? "").isEmpty
        }
        guard hasContent else { return nil }
        let margin = bates.margin
        let slots: [[String: Any]] = (0..<6).map { index in
            [
                "position": self.headerFooterPosition(index),
                "text": bates.text(at: UInt(index)) ?? "",
                "font_name": bates.fontName(at: UInt(index)) ?? "Helvetica",
                "font_size": Double(bates.fontSize(at: UInt(index))),
                "text_color": bates.textColor(at: UInt(index))?.toHexString() ?? "#000000"
            ]
        }
        return [
            "pages": bates.pageString ?? "",
            "margin": [
                "left": Double(margin.left), "top": Double(margin.top),
                "right": Double(margin.right), "bottom": Double(margin.bottom)
            ],
            "page_offset": 0,
            "rule": 2,
            "slots": slots
        ]
    }

    private func updateBates(call: FlutterMethodCall, result: FlutterResult) {
        guard let bates = self.document?.bates(),
              let info = call.arguments as? [String: Any],
              let pages = info["pages"] as? String, !pages.isEmpty,
              let margin = info["margin"] as? [String: Any],
              let slots = info["slots"] as? [[String: Any]], !slots.isEmpty,
              let left = self.headerFooterNumber(margin["left"]),
              let top = self.headerFooterNumber(margin["top"]),
              let right = self.headerFooterNumber(margin["right"]),
              let bottom = self.headerFooterNumber(margin["bottom"]) else {
            result(FlutterError(code: "BATES_FAIL", message: "Bates payload is invalid.", details: nil))
            return
        }
        var positions = Set<Int>()
        for slot in slots {
            guard let position = slot["position"] as? String,
                  let index = self.headerFooterIndex(position),
                  positions.insert(index).inserted,
                  let fontSize = self.headerFooterNumber(slot["font_size"]), fontSize > 0 else {
                result(FlutterError(code: "BATES_FAIL", message: "Bates slot is invalid.", details: nil))
                return
            }
        }
        bates.pageString = pages
        bates.margin = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        for index in 0..<6 { bates.setText("", at: UInt(index)) }
        for slot in slots {
            guard let position = slot["position"] as? String,
                  let index = self.headerFooterIndex(position),
                  let fontSize = self.headerFooterNumber(slot["font_size"]) else { continue }
            bates.setText(slot["text"] as? String ?? "", at: UInt(index))
            bates.setFontName(slot["font_name"] as? String ?? "Helvetica", at: UInt(index))
            bates.setFontSize(fontSize, at: UInt(index))
            bates.setTextColor(
                ColorHelper.colorWithHexString(hex: slot["text_color"] as? String ?? "#FF000000"),
                at: UInt(index))
        }
        bates.update()
        self.pdfViewController?.pdfListView?.layoutDocumentView()
        result(true)
    }

    private func backgroundMap() -> [String: Any]? {
        guard let background = self.document?.background(),
              background.hasBackground else {
            return nil
        }
        let pages = background.pageString
        print("ComPDFKit-Flutter: getBackground background.pages: \(pages ?? "<nil>")")
        var value: [String: Any] = [
            "pages": pages ?? "",
            "type": background.type == .image ? "image" : "color",
            "opacity": Double(background.opacity),
            "scale": Double(background.scale),
            "rotation": Double(background.rotation),
            "horizontal_alignment": self.backgroundHorizontalAlignment(
                Int(background.horizontalAlignment)),
            "vertical_alignment": self.backgroundVerticalAlignment(
                Int(background.verticalAlignment)),
            "horizontal_offset": Double(background.xOffset),
            "vertical_offset": Double(background.yOffset),
            "allow_view": background.isAllowsView,
            "allow_print": background.isAllowsPrint
        ]
        if background.type == .color {
            value["color"] = self.backgroundColorHex(background.color)
        }
        return value
    }

    private func updateBackground(call: FlutterMethodCall, result: FlutterResult) {
        guard let background = self.document?.background(),
              let info = call.arguments as? [String: Any],
              let pages = info["pages"] as? String,
              !pages.isEmpty,
              let type = info["type"] as? String,
              let opacity = self.backgroundNumber(info["opacity"]),
              let scale = self.backgroundNumber(info["scale"]),
              let rotation = self.backgroundNumber(info["rotation"]),
              let horizontalAlignment = self.backgroundHorizontalAlignment(
                info["horizontal_alignment"] as? String),
              let verticalAlignment = self.backgroundVerticalAlignment(
                info["vertical_alignment"] as? String),
              let horizontalOffset = self.backgroundNumber(info["horizontal_offset"]),
              let verticalOffset = self.backgroundNumber(info["vertical_offset"]),
              let allowView = info["allow_view"] as? Bool,
              let allowPrint = info["allow_print"] as? Bool else {
            result(FlutterError(
                code: "BACKGROUND_FAIL",
                message: "Background payload is invalid.",
                details: nil))
            return
        }

        switch type {
        case "color":
            guard let color = info["color"] as? String, !color.isEmpty else {
                result(FlutterError(
                    code: "BACKGROUND_FAIL",
                    message: "A color background requires color.",
                    details: nil))
                return
            }
            background.type = .color
            background.color = ColorHelper.colorWithHexString(hex: color)
        case "image":
            guard let imagePath = info["image_path"] as? String,
                  !imagePath.isEmpty,
                  let image = UIImage(contentsOfFile: imagePath) else {
                result(FlutterError(
                    code: "BACKGROUND_FAIL",
                    message: "Background image_path does not exist.",
                    details: nil))
                return
            }
            background.type = .image
            background.setImage(image)
        default:
            result(FlutterError(
                code: "BACKGROUND_FAIL",
                message: "Background type is invalid.",
                details: nil))
            return
        }

        background.pageString = pages
        background.opacity = opacity
        background.scale = scale
        background.rotation = rotation
        background.horizontalAlignment = UInt(horizontalAlignment)
        background.verticalAlignment = UInt(verticalAlignment)
        background.xOffset = horizontalOffset
        background.yOffset = verticalOffset
        background.isAllowsView = allowView
        background.isAllowsPrint = allowPrint
        background.update()
        self.pdfViewController?.pdfListView?.layoutDocumentView()
        result(true)
    }

    private func backgroundNumber(_ value: Any?) -> CGFloat? {
        guard let number = value as? NSNumber else {
            return nil
        }
        return CGFloat(number.doubleValue)
    }

    private func backgroundHorizontalAlignment(_ value: String?) -> Int? {
        switch value {
        case "left": return 0
        case "center": return 1
        case "right": return 2
        default: return nil
        }
    }

    private func backgroundVerticalAlignment(_ value: String?) -> Int? {
        switch value {
        case "top": return 0
        case "center": return 1
        case "bottom": return 2
        default: return nil
        }
    }

    private func backgroundHorizontalAlignment(_ value: Int) -> String {
        switch value {
        case 0: return "left"
        case 2: return "right"
        default: return "center"
        }
    }

    private func backgroundVerticalAlignment(_ value: Int) -> String {
        switch value {
        case 0: return "top"
        case 2: return "bottom"
        default: return "center"
        }
    }

    private func backgroundColorHex(_ color: UIColor?) -> String {
        guard let color = color else {
            return "#00000000"
        }
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "#00000000"
        }
        return String(
            format: "#%02X%02X%02X%02X",
            Int((alpha * 255).rounded()),
            Int((red * 255).rounded()),
            Int((green * 255).rounded()),
            Int((blue * 255).rounded()))
    }

    private func headerFooterNumber(_ value: Any?) -> CGFloat? {
        if let number = value as? NSNumber {
            return CGFloat(number.doubleValue)
        }
        return nil
    }

    private func headerFooterIndex(_ position: String) -> Int? {
        switch position {
        case "header_left": return 0
        case "header_center": return 1
        case "header_right": return 2
        case "footer_left": return 3
        case "footer_center": return 4
        case "footer_right": return 5
        default: return nil
        }
    }

    private func headerFooterPosition(_ index: Int) -> String {
        switch index {
        case 0: return "header_left"
        case 1: return "header_center"
        case 2: return "header_right"
        case 3: return "footer_left"
        case 4: return "footer_center"
        case 5: return "footer_right"
        default: return "header_left"
        }
    }

    private func renderAnnotationAppearance(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let info = call.arguments as? [String: Any]
        let pageIndex = self.getValue(from: info, key: "page_index", defaultValue: -1)
        let uuid = self.getValue(from: info, key: "uuid", defaultValue: "")
        let options = info?["options"] as? [String: Any]

        guard let document = self.document else {
            result(FlutterError(
                code: "RENDER_ANNOTATION_APPEARANCE_FAIL",
                message: "document is nil",
                details: nil))
            return
        }

        guard pageIndex >= 0 && pageIndex < document.pageCount else {
            result(FlutterError(
                code: "RENDER_ANNOTATION_APPEARANCE_FAIL",
                message: "Invalid page index: \(pageIndex)",
                details: nil))
            return
        }

        guard !uuid.isEmpty else {
            result(FlutterError(
                code: "RENDER_ANNOTATION_APPEARANCE_FAIL",
                message: "Annotation uuid is empty",
                details: nil))
            return
        }

        let page = document.page(at: UInt(pageIndex))
        let pageUtil = CPDFPageUtil(page: page)

        DispatchQueue.global(qos: .userInitiated).async {
            guard let annotation = pageUtil.getAnnotation(formUUID: uuid) else {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "RENDER_ANNOTATION_APPEARANCE_FAIL",
                        message: "Annotation was not found",
                        details: nil))
                }
                return
            }

            let renderSize = self.resolveAnnotationAppearanceRenderSize(
                bounds: annotation.bounds,
                options: options)

            guard let data = self.renderAnnotationAppearanceData(
                annotation: annotation,
                size: renderSize,
                options: options) else {
                DispatchQueue.main.async {
                    result(FlutterError(
                        code: "RENDER_ANNOTATION_APPEARANCE_FAIL",
                        message: "Failed to render annotation appearance",
                        details: nil))
                }
                return
            }

            DispatchQueue.main.async {
                result(data)
            }
        }
    }

    private func renderAnnotationAppearanceData(
        annotation: CPDFAnnotation,
        size: CGSize,
        options: [String: Any]?
    ) -> Data? {
        //TODO: 渲染 Markup, Ink, FreeText, Link, Sound类型异常
        let image : UIImage = annotation.anntationImage()
        guard size.width > 0, size.height > 0 else {
            return nil
        }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let renderedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }

        let compression = self.getValue(
            from: options,
            key: "compression",
            defaultValue: "png")
        let quality = min(max(self.getValue(from: options, key: "quality", defaultValue: 100), 1), 100)

        if compression == "jpeg" {
            return renderedImage.jpegData(compressionQuality: CGFloat(quality) / 100.0)
        }

        return renderedImage.pngData()
    }

    private func resolveAnnotationAppearanceRenderSize(
        bounds: CGRect,
        options: [String: Any]?
    ) -> CGSize {
        let baseWidth = max(1, Int(abs(bounds.width).rounded()))
        let baseHeight = max(1, Int(abs(bounds.height).rounded()))
        let targetWidth = self.getValue(from: options, key: "target_width", defaultValue: 0)
        let targetHeight = self.getValue(from: options, key: "target_height", defaultValue: 0)
        let scale = self.getValue(from: options, key: "scale", defaultValue: 3.0)

        if targetWidth > 0 && targetHeight > 0 {
            return CGSize(width: targetWidth, height: targetHeight)
        }

        if targetWidth > 0 {
            let resolvedHeight = max(
                1,
                Int((Double(targetWidth) * (Double(baseHeight) / Double(baseWidth))).rounded()))
            return CGSize(width: targetWidth, height: resolvedHeight)
        }

        if targetHeight > 0 {
            let resolvedWidth = max(
                1,
                Int((Double(targetHeight) * (Double(baseWidth) / Double(baseHeight))).rounded()))
            return CGSize(width: resolvedWidth, height: targetHeight)
        }

        let scaledWidth = max(1, Int((Double(baseWidth) * scale).rounded()))
        let scaledHeight = max(1, Int((Double(baseHeight) * scale).rounded()))
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
    
    func convertOutlineToDict(_ outline: CPDFOutline?, level: Int = 0) -> [String: Any]? {
        guard let outline = outline else { return nil }
        
        var dict: [String: Any] = [:]
        dict["title"] = outline.label ?? ""
        dict["level"] = level
        dict["tag"] = ""
        
        let destination = outline.destination
        if let dest = destination {
            dict["destination"] = [
                "pageIndex": dest.pageIndex
            ]
        }
        var actionDict: [String: Any] = [:]
        if let action = outline.action as? CPDFGoToAction {
            actionDict["actionType"] = "goTo"
            dict["action"] = actionDict
        } else if let action = outline.action as? CPDFURLAction {
            actionDict["actionType"] = "uri"
            actionDict["uri"] = action.url() ?? ""
            dict["action"] = actionDict
        }
        
        var children: [[String: Any]] = []
        for i in 0..<outline.numberOfChildren {
            if let child = outline.child(at: i),
               let childDict = convertOutlineToDict(child, level: level + 1) {
                children.append(childDict)
            }
        }
        dict["childList"] = children
        return dict
    }
    
    
    func convertOutlineToJSONString(_ outline: CPDFOutline?) -> String? {
        guard let dict = convertOutlineToDict(outline, level:  0) else {
            return nil
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            return String(data: jsonData, encoding: .utf8)
        } else {
            return nil
        }
    }
}
