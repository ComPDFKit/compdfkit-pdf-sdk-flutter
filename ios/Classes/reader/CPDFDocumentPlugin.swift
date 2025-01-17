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
            case CPDFConstants.save:
                // save pdf
                guard let pdfListView = self.pdfViewController!.pdfListView else {
                    result(true)
                    return
                }
                var isSuccess = false
                if (pdfListView.isEditing() == true && pdfListView.isEdited() == true) {
                    pdfListView.commitEditing()
                    if pdfListView.document.isModified() == true {
                        isSuccess = pdfListView.document.write(to: pdfListView.document.documentURL)
                    }
                    
                } else {
                    if(pdfListView.document != nil) {
                        if pdfListView.document.isModified() == true {
                            isSuccess = pdfListView.document.write(to: pdfListView.document.documentURL)
                        }
                    }
                }
                
                if isSuccess {
                    self._methodChannel.invokeMethod("saveDocument", arguments: nil)
                }
                result(isSuccess) // or return false
            case CPDFConstants.openDocument:
                let initInfo = call.arguments as? [String: Any]
                let path = initInfo?["filePath"] as? String ?? ""
                let password = initInfo?["password"] ?? ""
                
                self.document = CPDFDocument(url: URL(fileURLWithPath: path))
                if(self.document?.isLocked == true){
                    self.document?.unlock(withPassword: password as? String ?? "")
                }
                self.pdfViewController?.pdfListView?.document = self.document
                self.pdfViewController?.pdfListView?.setNeedsDisplay()
                result(true)
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
              
                var success = false
             
                if removeSecurity {
                    success = self.document?.writeDecrypt(to: URL(fileURLWithPath: savePath), isSaveFontSubset: fontSubSet) ?? false
                } else {
                    success = self.document?.write(to: URL(fileURLWithPath: savePath), isSaveFontSubset: fontSubSet) ?? false
                }
               
                result(success)
            case CPDFConstants.print:
                self.pdfViewController?.enterPrintState()
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
            default:
                result(FlutterMethodNotImplemented)
            }
        });
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
}
