//
//  CPDFDocumentPlugin.swift
//  compdfkit_flutter
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
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
    
    init(pdfViewController : CPDFViewController, uid : String, binaryMessager : FlutterBinaryMessenger){
        self.pdfViewController = pdfViewController
        _methodChannel = FlutterMethodChannel(name: "com.compdfkit.flutter.document_\(uid)", binaryMessenger: binaryMessager)
        registeryMethodChannel()
    }
    
    
    private func registeryMethodChannel(){

        _methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            print("ComPDFKit-Flutter: iOS-MethodChannel: CPDFDocumentPlugin [method:\(call.method)]")
            if(self.document == nil && self.pdfViewController != nil){
                guard let pdfListView = self.pdfViewController?.pdfListView else {
                    print("pdfViewController error")
                    return
                }
                self.document = pdfListView.document
            }
            switch call.method {
            case "open_document":
                let initInfo = call.arguments as? [String: Any]
                let path = initInfo?["filePath"] as? String ?? ""
                let password = initInfo?["password"] ?? ""
                
                self.document = CPDFDocument(url: URL(fileURLWithPath: path))
                if(self.document?.isLocked == true){
                    self.document?.unlock(withPassword: password as? String ?? "")
                }
                self.pdfViewController?.pdfListView?.document = self.document
                self.pdfViewController?.pdfListView?.setNeedsDisplay()
                result(2)
            case "get_file_name":
                
                if(self.document == nil){
                    print("self.document is nil")
                    result("is nil")
                    return
                }
                let fileName = self.document?.documentURL.lastPathComponent
                result(fileName)
            case "is_encrypted":
                let isEncrypted = self.document?.isEncrypted ?? false
                result(isEncrypted)
            case "is_image_doc":
                let isImageDoc = self.document?.isImageDocument() ?? false
                result(isImageDoc)
            case "get_permissions":
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
                
            case "check_owner_unlocked":
                let owner = self.document?.isCheckOwnerUnlocked() ?? false
                
                result(owner)
            case "check_password":
                let info = call.arguments as? [String: Any]
                let password = info?["password"] as? String ?? ""
                let isOwnerPassword = self.document?.checkOwnerPassword(password) ?? false
                result(isOwnerPassword)
            case "has_change":
                let isModified = self.document?.isModified() ?? false
                result(isModified)
            case "import_annotations":
                let importPath = call.arguments as? String ?? ""
                let success = self.document?.importAnnotation(fromXFDFPath: importPath) ?? false
                if success {
                    self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                }
                result(success)
            case "export_annotations":
                let fileNameWithExtension = self.document?.documentURL.lastPathComponent ?? ""
                let fileName = (fileNameWithExtension as NSString).deletingPathExtension
                let documentFolder = NSHomeDirectory().appending("/Documents/\(fileName)_xfdf.xfdf")
                let succes = self.document?.exportAnnotation(toXFDFPath: documentFolder) ?? false
                if succes {
                    result(documentFolder)
                } else {
                    result("")
                }
            case "remove_all_annotations":
                let pageCount = self.document?.pageCount ?? 0
                for i in 0..<pageCount {
                    let page = self.document?.page(at: i)
                    page?.removeAllAnnotations()
                }
                self.pdfViewController?.pdfListView?.setNeedsDisplayForVisiblePages()
                self.pdfViewController?.pdfListView?.updateActiveAnnotations([])
                result(true)
            case "get_page_count":
                let count = self.document?.pageCount ?? 1
                result(count)
            default:
                result(FlutterMethodNotImplemented)
            }
        });
        
    }
}
