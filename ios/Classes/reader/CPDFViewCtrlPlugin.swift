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
    
    private var _methodChannel : FlutterMethodChannel
    
    private var pdfViewController : CPDFViewController
    
    init(viewId: Int64, binaryMessenger messenger: FlutterBinaryMessenger, controller : CPDFViewController) {
        self.pdfViewController = controller
        _methodChannel = FlutterMethodChannel.init(name: "com.compdfkit.flutter.ui.pdfviewer.\(viewId)", binaryMessenger: messenger)
        registeryMethodChannel(viewId: viewId, binaryMessenger: messenger)
    }
    
    
    private func registeryMethodChannel(viewId: Int64, binaryMessenger messenger: FlutterBinaryMessenger){

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
            case "has_change":
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.document.isModified())
            default:
                result(FlutterMethodNotImplemented)
            }
        });
        
    }
    
}
