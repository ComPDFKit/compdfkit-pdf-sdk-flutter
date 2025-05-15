//
//  CPDFViewCtrlPlugin.swift
//
//  Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
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
            case CPDFConstants.setScale:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let scaleValue = call.arguments as! NSNumber
                pdfListView.setScaleFactor(CGFloat(truncating: scaleValue), animated: true)
            case CPDFConstants.getScale:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(1.0)
                    return
                }
                result(pdfListView.scaleFactor)
            case CPDFConstants.setReadBackgroundColor:
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
            case CPDFConstants.getReadBackgroundColor:
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
               
            case CPDFConstants.setFromFieldHighlight:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let highlightForm = call.arguments as! Bool
                CPDFKitConfig.sharedInstance().setEnableFormFieldHighlight(highlightForm)
                pdfListView.layoutDocumentView()
            case CPDFConstants.isFromFieldHighlight:
                result(CPDFKitConfig.sharedInstance().enableFormFieldHighlight())
            case CPDFConstants.setLinkHighlight:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let linkHighlight = call.arguments as! Bool
                CPDFKitConfig.sharedInstance().setEnableLinkFieldHighlight(linkHighlight)
                pdfListView.layoutDocumentView()
            case CPDFConstants.isLinkHighlight:
                result(CPDFKitConfig.sharedInstance().enableLinkFieldHighlight())
            case CPDFConstants.setVerticalMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let verticalMode = call.arguments as! Bool
                pdfListView.displayDirection = verticalMode ? .vertical : .horizontal
                pdfListView.layoutDocumentView()
            case CPDFConstants.isVerticalMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(true)
                    return
                }
                result(pdfListView.displayDirection == .vertical)
            case CPDFConstants.setPageSpacing:
                result(FlutterError(code: "NOT_SUPPORT", message: "This method is not supported on iOS. Please use controller.setMargins(left,top,right,bottom)", details: ""))
            case CPDFConstants.setMargin:
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
            case CPDFConstants.setContinueMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let continueMode = call.arguments as! Bool
                pdfListView.displaysPageBreaks = continueMode
                pdfListView.layoutDocumentView()
            case CPDFConstants.isContinueMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(true)
                    return
                }
                result(pdfListView.displaysPageBreaks)
            case CPDFConstants.setDoublePageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let twoUp = call.arguments as! Bool
                pdfListView.displayTwoUp = twoUp
                pdfListView.displaysAsBook = false
                pdfListView.layoutDocumentView()
            case CPDFConstants.isDoublePageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displayTwoUp)
            case CPDFConstants.setCoverPageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let coverPageMode = call.arguments as! Bool
                pdfListView.displaysAsBook = coverPageMode
                pdfListView.displayTwoUp = coverPageMode
                pdfListView.layoutDocumentView()
            case CPDFConstants.isCoverPageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displaysAsBook)
            case CPDFConstants.setCropMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let cropMode = call.arguments as! Bool
                pdfListView.displayCrop = cropMode
                pdfListView.layoutDocumentView()
            case CPDFConstants.isCropMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displayCrop)
            case CPDFConstants.setDisplayPageIndex:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    return
                }
                let info =  call.arguments as! [String: Any]
                let pageIndex = info["pageIndex"] as! NSNumber
                let animated = info["animated"] as! Bool
                pdfListView.go(toPageIndex: Int(truncating: pageIndex), animated: animated)
            case CPDFConstants.getCurrentPageIndex:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(0)
                    return
                }
                result(pdfListView.currentPageIndex)
            case CPDFConstants.set_preview_mode:
                let mode = call.arguments as! String
                switch mode {
                case "viewer":
                    self.pdfViewController.enterViewerMode()
                case "annotations":
                    self.pdfViewController.enterAnnotationMode()
                case "contentEditor":
                    self.pdfViewController.enterEditMode()
                case "forms":
                    self.pdfViewController.enterFormMode()
                case "signatures":
                    self.pdfViewController.enterSignatureMode()
                    default:
                    self.pdfViewController.enterViewerMode()
                }
            case CPDFConstants.get_preview_mode:
                let state = self.pdfViewController.functionTypeState
                switch state {
                case .viewer:
                    result("viewer")
                case .edit:
                    result("contentEditor")
                case .annotation:
                    result("annotations")
                case .form:
                    result("forms")
                case .signature:
                    result("signatures")
                default:
                    result("viewer")
                }
            case CPDFConstants.showThumbnailView:
                let editMode = call.arguments as! Bool
                
                if editMode {
                    self.pdfViewController.enterPDFPageEdit()
                } else {
                    self.pdfViewController.enterThumbnail()
                }
            case CPDFConstants.showBotaView:
                self.pdfViewController.buttonItemClicked_Bota(UIButton(frame: .zero))
            case CPDFConstants.showAddWatermarkView:
                let isSaveAs = call.arguments as! Bool
                self.pdfViewController.enterPDFWatermark(isSaveAs: isSaveAs)
            case CPDFConstants.showSecurityView:
                self.pdfViewController.enterPDFSecurity()
            case CPDFConstants.showDisplaySettingsView:
                self.pdfViewController.enterPDFSetting()
            case CPDFConstants.enterSnipMode:
                self.pdfViewController.enterPDFSnipImageMode()
            case CPDFConstants.exitSnipMode:
                self.pdfViewController.exitPDFSnipImageMode()
            case CPDFConstants.reloadPages:
                self.pdfViewController.pdfListView?.setNeedsDisplayForVisiblePages()
                self.pdfViewController.pdfListView?.layoutDocumentView()
            default:
                result(FlutterMethodNotImplemented)
            }
        });
        
    }
    
}
