//
//  CPDFViewCtrlPlugin.swift
//
//  Copyright © 2014-2023 PDF Technologies, Inc. All Rights Reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.

import Flutter
import UIKit
import ComPDFKit
import ComPDFKit_Tools

class CPDFViewCtrlPlugin {
    
    public var _methodChannel : FlutterMethodChannel
    
    private var pdfViewController : CPDFViewController
    
    init(viewId: Int64, binaryMessenger messenger: FlutterBinaryMessenger, controller : CPDFViewController) {
        self.pdfViewController = controller
        _methodChannel = FlutterMethodChannel.init(name: "com.compdfkit.flutter.ui.pdfviewer.\(viewId)", binaryMessenger: messenger)
        registeryMethodChannel()

        var documentPlugin = CPDFDocumentPlugin(pdfViewController: pdfViewController, uid: String(describing: viewId), binaryMessager: messenger)
    }
    
    
    private func registeryMethodChannel(){

        _methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            print("ComPDFKit-Flutter: iOS-MethodChannel: [method:\(call.method)]")
              // Handle battery messages.
            switch call.method {
            case "save":
                // save pdf
                guard let pdfListView = self.pdfViewController.pdfListView else {
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
            case "set_scale":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let scaleValue = call.arguments as! NSNumber
                pdfListView.setScaleFactor(CGFloat(truncating: scaleValue), animated: true)
            case "get_scale":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(1.0)
                    return
                }
                result(pdfListView.scaleFactor)
            case "set_read_background_color":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
           
                let initInfo = call.arguments as? [String: String]
                let displayModeName = initInfo?["displayMode"] ?? "light"
                // light, dark,repia, reseda
                switch displayModeName {
                case "light":
                    pdfListView.displayMode = .normal
                case "dark":
                    pdfListView.displayMode = .night
                case "sepia":
                    pdfListView.displayMode = .soft
                case "reseda":
                    pdfListView.displayMode = .green
                default:
                    pdfListView.displayMode = .normal
                }

                pdfListView.layoutDocumentView()
            case "get_read_background_color":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result("#FFFFFF")
                    return
                }
                let dispalyMode = pdfListView.displayMode
                switch dispalyMode {
                    
                case .normal:
                    result("#FFFFFF")
                case .night:
                    result("#000000")
                case .soft:
                    result("#FFFFFF")
                case .green:
                    result("#FFEFBE")
                case .custom:
                    result("#CDE6D0")
                @unknown default:
                    result("#FFFFFF")
                }
               
            case "set_form_field_highlight":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let highlightForm = call.arguments as! Bool
                CPDFKitConfig.sharedInstance().setEnableFormFieldHighlight(highlightForm)
                pdfListView.layoutDocumentView()
            case "is_form_field_highlight":
                result(CPDFKitConfig.sharedInstance().enableFormFieldHighlight())
            case "set_link_highlight":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let linkHighlight = call.arguments as! Bool
                CPDFKitConfig.sharedInstance().setEnableLinkFieldHighlight(linkHighlight)
                pdfListView.layoutDocumentView()
            case "is_link_highlight":
                result(CPDFKitConfig.sharedInstance().enableLinkFieldHighlight())
            case "set_vertical_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let verticalMode = call.arguments as! Bool
                pdfListView.displayDirection = verticalMode ? .vertical : .horizontal
                pdfListView.layoutDocumentView()
            case "is_vertical_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(true)
                    return
                }
                result(pdfListView.displayDirection == .vertical)
            case "set_page_spacing":
                result(FlutterError(code: "NOT_SUPPORT", message: "This method is not supported on iOS. Please use controller.setMargins(left,top,right,bottom)", details: ""))
            case "set_margin":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let spacingInfo = call.arguments as! [String: NSNumber]
                
                pdfListView.pageBreakMargins = .init(
                    top: CGFloat(truncating: (spacingInfo["top"] ?? 10)),
                    left: CGFloat(truncating: (spacingInfo["left"] ?? 10)),
                    bottom: CGFloat(truncating: (spacingInfo["bottom"] ?? 10)),
                    right: CGFloat(truncating: (spacingInfo["right"] ?? 10))
                    )
                pdfListView.layoutDocumentView()
            case "set_continue_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let continueMode = call.arguments as! Bool
                pdfListView.displaysPageBreaks = continueMode
                pdfListView.layoutDocumentView()
            case "is_continue_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(true)
                    return
                }
                result(pdfListView.displaysPageBreaks)
            case "set_double_page_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let twoUp = call.arguments as! Bool
                pdfListView.displayTwoUp = twoUp
                pdfListView.displaysAsBook = false
                pdfListView.layoutDocumentView()
            case "is_double_page_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displayTwoUp)
            case "set_cover_page_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let coverPageMode = call.arguments as! Bool
                pdfListView.displaysAsBook = coverPageMode
                pdfListView.displayTwoUp = coverPageMode
                pdfListView.layoutDocumentView()
            case "is_cover_page_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displaysAsBook)
            case "set_crop_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let cropMode = call.arguments as! Bool
                pdfListView.displayCrop = cropMode
                pdfListView.layoutDocumentView()
            case "is_crop_mode":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displayCrop)
            case "set_display_page_index":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let info =  call.arguments as! [String: Any]
                let pageIndex = info["pageIndex"] as! NSNumber
                let animated = info["animated"] as! Bool
                pdfListView.go(toPageIndex: Int(truncating: pageIndex), animated: animated)
            case "get_current_page_index":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(0)
                    return
                }
                result(pdfListView.currentPageIndex)
            default:
                result(FlutterMethodNotImplemented)
            }
        });
        
    }
    
}
