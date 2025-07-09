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
                    result(nil)
                    return
                }
                let scaleValue = call.arguments as! NSNumber
                pdfListView.setScaleFactor(CGFloat(truncating: scaleValue), animated: true)
                result(nil)
            case CPDFConstants.getScale:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(1.0)
                    return
                }
                result(pdfListView.scaleFactor)
            case CPDFConstants.setReadBackgroundColor:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
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
                result(nil)
            case CPDFConstants.setWidgetBackgroundColor:
                let hexColor = call.arguments as? String ?? ""
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                
                pdfListView.backgroundColor = ColorHelper.colorWithHexString(hex: hexColor)
                result(nil)
                
            case CPDFConstants.getReadBackgroundColor:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result("#FFFFFF")
                    return
                }
                let dispalyMode = pdfListView.displayMode
                switch dispalyMode {
                    
                case .normal:
                    result("#FFFFFFFF")
                case .night:
                    result("#FF000000")
                case .soft:
                    result("#FFFFEFBE")
                case .green:
                    result("#FFCDE6D0")
                case .custom:
                    result("#CDE6D0")
                @unknown default:
                    result("#FFFFFFFF")
                }
               
            case CPDFConstants.setFromFieldHighlight:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let highlightForm = call.arguments as! Bool
                CPDFKitConfig.sharedInstance().setEnableFormFieldHighlight(highlightForm)
                pdfListView.layoutDocumentView()
                result(nil)
            case CPDFConstants.isFromFieldHighlight:
                result(CPDFKitConfig.sharedInstance().enableFormFieldHighlight())
            case CPDFConstants.setLinkHighlight:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let linkHighlight = call.arguments as! Bool
                CPDFKitConfig.sharedInstance().setEnableLinkFieldHighlight(linkHighlight)
                pdfListView.layoutDocumentView()
                result(nil)
            case CPDFConstants.isLinkHighlight:
                result(CPDFKitConfig.sharedInstance().enableLinkFieldHighlight())
            case CPDFConstants.setVerticalMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let verticalMode = call.arguments as! Bool
                pdfListView.displayDirection = verticalMode ? .vertical : .horizontal
                pdfListView.layoutDocumentView()
                result(nil)
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
                    result(nil)
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
                result(nil)
            case CPDFConstants.setContinueMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let continueMode = call.arguments as! Bool
                pdfListView.displaysPageBreaks = continueMode
                pdfListView.layoutDocumentView()
                result(nil)
            case CPDFConstants.isContinueMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(true)
                    return
                }
                result(pdfListView.displaysPageBreaks)
            case CPDFConstants.setDoublePageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let twoUp = call.arguments as! Bool
                pdfListView.displayTwoUp = twoUp
                pdfListView.displaysAsBook = false
                pdfListView.layoutDocumentView()
                result(nil)
            case CPDFConstants.isDoublePageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displayTwoUp)
            case CPDFConstants.setCoverPageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let coverPageMode = call.arguments as! Bool
                pdfListView.displaysAsBook = coverPageMode
                pdfListView.displayTwoUp = coverPageMode
                pdfListView.layoutDocumentView()
                result(nil)
            case CPDFConstants.isCoverPageMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displaysAsBook)
            case CPDFConstants.setCropMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let cropMode = call.arguments as! Bool
                pdfListView.displayCrop = cropMode
                pdfListView.layoutDocumentView()
                result(nil)
            case CPDFConstants.isCropMode:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(false)
                    return
                }
                result(pdfListView.displayCrop)
            case CPDFConstants.setDisplayPageIndex:
                guard let pdfListView = self.pdfViewController.pdfListView else {
                    result(nil)
                    return
                }
                let info =  call.arguments as! [String: Any]
                let pageIndex = info["pageIndex"] as! NSNumber
                let animated = info["animated"] as! Bool
                pdfListView.go(toPageIndex: Int(truncating: pageIndex), animated: animated)
                result(nil)
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
                result(nil)
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
                    self.pdfViewController.enterThumbnail(false)
                } else {
                    self.pdfViewController.enterThumbnail(true)
                }
                result(nil)
            case CPDFConstants.showBotaView:
                self.pdfViewController.buttonItemClicked_Bota(UIButton(frame: .zero))
                result(nil)
            case CPDFConstants.showAddWatermarkView:
                let isSaveAs = call.arguments as! Bool
                self.pdfViewController.enterPDFWatermark(isSaveAs: isSaveAs)
                result(nil)
            case CPDFConstants.showSecurityView:
                self.pdfViewController.enterPDFSecurity()
                result(nil)
            case CPDFConstants.showDisplaySettingsView:
                self.pdfViewController.enterPDFSetting()
                result(nil)
            case CPDFConstants.enterSnipMode:
                self.pdfViewController.enterPDFSnipImageMode()
                result(nil)
            case CPDFConstants.exitSnipMode:
                self.pdfViewController.exitPDFSnipImageMode()
                result(nil)
            case CPDFConstants.reloadPages:
                self.pdfViewController.pdfListView?.setNeedsDisplayForVisiblePages()
                self.pdfViewController.pdfListView?.layoutDocumentView()
                result(nil)
            case CPDFConstants.setAnnotationMode:
                let mode = call.arguments as? String ?? "unknown"
                var annotationMode: CPDFViewAnnotationMode = .CPDFViewAnnotationModenone
                switch mode {
                case "note":
                    annotationMode = .note
                case "highlight":
                    annotationMode = .highlight
                case "underline":
                    annotationMode = .underline
                case "strikeout":
                    annotationMode = .strikeout
                case "squiggly":
                    annotationMode = .squiggly
                case "ink":
                    annotationMode = .ink
                case "ink_eraser":
                    annotationMode = .eraser
                case "pencil":
                    annotationMode = .pencilDrawing
                case "circle":
                    annotationMode = .circle
                case "square":
                    annotationMode = .square
                case "arrow":
                    annotationMode = .arrow
                case "line":
                    annotationMode = .line
                case "freetext":
                    annotationMode = .freeText
                case "signature":
                    annotationMode = .signature
                case "stamp":
                    annotationMode = .stamp
                case "pictures":
                    annotationMode = .image
                case "link":
                    annotationMode = .link
                case "sound":
                    annotationMode = .sound
                case "unknown":
                    annotationMode = .CPDFViewAnnotationModenone
                    default:
                    break
                }
                    
                self.pdfViewController.annotationBar?.annotationToolBarSwitch(annotationMode)
                result(nil)
            case CPDFConstants.getAnnotationMode:
                let annotationMode = self.pdfViewController.pdfListView?.annotationMode ?? .CPDFViewAnnotationModenone
                var mode = "unknown"
                switch annotationMode {
                case .note:
                    mode = "note"
                case .highlight:
                    mode = "highlight"
                case .underline:
                    mode = "underline"
                case .strikeout:
                    mode = "strikeout"
                case .squiggly:
                    mode = "squiggly"
                case .ink:
                    mode = "ink"
                case .eraser:
                    mode = "ink_eraser"
                case .pencilDrawing:
                    mode = "pencil"
                case .circle:
                    mode = "circle"
                case .square:
                    mode = "square"
                case .arrow:
                    mode = "arrow"
                case .line:
                    mode = "line"
                case .freeText:
                    mode = "freetext"
                case .signature:
                    mode = "signature"
                case .stamp:
                    mode = "stamp"
                case .image:
                    mode = "pictures"
                case .link:
                    mode = "link"
                case .sound:
                    mode = "sound"
                case .CPDFViewAnnotationModenone:
                    mode = "unknown"
                    default:
                    break
                }
                result(mode)
            case CPDFConstants.annotationCanRedo:
                let canRedo:Bool = self.pdfViewController.pdfListView?.canRedo() ?? false
                result(canRedo)
            case CPDFConstants.annotationCanUndo:
                let canUndo = self.pdfViewController.pdfListView?.canUndo() ?? false
                result(canUndo)
            case CPDFConstants.annotationRedo:
                self.pdfViewController.pdfListView?.undoPDFManager?.redo()
                result(nil)
            case CPDFConstants.annotationUndo:
                self.pdfViewController.pdfListView?.undoPDFManager?.undo()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        });
        
    }
    
}
