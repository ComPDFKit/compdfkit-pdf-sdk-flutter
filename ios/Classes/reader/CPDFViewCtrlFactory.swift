//
//  CPDFViewCtrlFactory.swift
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

class CPDFViewCtrlFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return CPDFViewCtrlFlutter(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class CPDFViewCtrlFlutter: NSObject, FlutterPlatformView, CPDFViewBaseControllerDelete {
    
    private var pdfViewController : CPDFViewController
    
    private var navigationController : CNavigationController
    
    private var _methodChannel : FlutterMethodChannel
    

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        // Parses the document path, password, and configuration information
        let initInfo = args as? [String: Any]
        let jsonString = initInfo?["configuration"] ?? ""
        let password = initInfo?["password"] ?? ""
        let path = initInfo?["document"] as? String ?? ""
        
        let jsonDataParse = CPDFJSONDataParse(String: jsonString as! String)
        let configuration = jsonDataParse.configuration
        
        // Create the pdfview controller view
        pdfViewController = CPDFViewController(filePath: path, password: password as? String, configuration: configuration!)
        
        navigationController = CNavigationController(rootViewController: pdfViewController)
        navigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationController.view.frame = frame
        
        _methodChannel = FlutterMethodChannel.init(name: "com.compdfkit.flutter.ui.pdfviewer.\(viewId)", binaryMessenger: messenger!)
        
        super.init()
        
        // Proxy set, but not used
        pdfViewController.delegate = self
        
        navigationController.setViewControllers([pdfViewController], animated: false)
        
        registeryMethodChannel(viewId: viewId, binaryMessenger: messenger!)
        
    }

    func view() -> UIView {
        return navigationController.view
    }
        
    public func PDFViewBaseControllerDissmiss(_ baseControllerDelete: CPDFViewBaseController) {
        baseControllerDelete.dismiss(animated: true)
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
            default:
                result(FlutterMethodNotImplemented)
            }
        });
        
    }
}



