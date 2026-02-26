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
import ComPDFKit
import Flutter
import ComPDFKit_Tools

public class CPDFDocumentPlugin {
    
    private var document : CPDFDocument?
    
    public var _methodChannel : FlutterMethodChannel
    
    private var pdfViewController : CPDFViewController?
    
    
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
            case CPDFConstants.createWatermark:
                self.createWatermark(call: call, result: result)
            case CPDFConstants.removeAllWatermark:
                let watrmarks = self.document?.watermarks() ?? []
                for watermark in watrmarks {
                    self.document?.removeWatermark(watermark)
                }
                let url = self.document?.documentURL
                self.document?.write(to: url, isSaveFontSubset: true)
                self.pdfViewController?.pdfListView?.layoutDocumentView()
                result(nil)
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
                //                let backgroundColor = self.getValue(from: info, key: "background_color", defaultValue: "#FFFFFF")
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
    
    private func createWatermark(call: FlutterMethodCall, result: FlutterResult) {
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
            let textWatermark = CPDFWatermark(document: self.document, type: .text)
            
            textWatermark?.text = textContent
            print("textColor:\(textColor)")
            let font = CPDFFont(familyName: "Helvetica", fontStyle: "")
            textWatermark?.cFont = font
            textWatermark?.opacity = opacity
            textWatermark?.fontSize = CGFloat(fontSize)
            textWatermark?.textColor = ColorHelper.colorWithHexString(hex: textColor)
            textWatermark?.scale = scale
            textWatermark?.isTilePage = isTilePage
            textWatermark?.isFront = isFront
            textWatermark?.tx = horizontalOffset
            textWatermark?.ty = verticalOffset
            textWatermark?.rotation = rotation
            textWatermark?.pageString = pages
            textWatermark?.horizontalPosition = horizontal
            textWatermark?.verticalPosition = vertical
            
            if textWatermark?.isTilePage == true {
                textWatermark?.verticalSpacing = verticalSpacing
                textWatermark?.horizontalSpacing = horizontalSpacing
            }
            
            self.document?.addWatermark(textWatermark)
            self.document?.updateWatermark(textWatermark)
        } else if type == "image" {
            let imageWatermark = CPDFWatermark(document: self.document, type: .image)
            
            imageWatermark?.image = UIImage.init(contentsOfFile: imagePath)
            imageWatermark?.opacity = opacity
            imageWatermark?.scale = scale
            imageWatermark?.isTilePage = isTilePage
            imageWatermark?.isFront = isFront
            imageWatermark?.tx = horizontalOffset
            imageWatermark?.ty = verticalOffset
            imageWatermark?.rotation = rotation
            imageWatermark?.pageString = pages
            imageWatermark?.horizontalPosition = horizontal
            imageWatermark?.verticalPosition = vertical
            
            if imageWatermark?.isTilePage == true {
                imageWatermark?.verticalSpacing = verticalSpacing
                imageWatermark?.horizontalSpacing = horizontalSpacing
            }
            
            self.document?.addWatermark(imageWatermark)
            self.document?.updateWatermark(imageWatermark)
        }
        
        
        self.pdfViewController?.pdfListView?.layoutDocumentView()
    }
    
    func getValue<T>(from info: [String: Any]?, key: String, defaultValue: T) -> T {
        guard let value = info?[key] as? T else {
            return defaultValue
        }
        return value
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
