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

    private var plugin : CPDFViewCtrlPlugin
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
        
        let document = NSURL(fileURLWithPath: path)
        
        var success = false
        var documentPath = path
        
        let homeDiectory = NSHomeDirectory()
        let bundlePath = Bundle.main.bundlePath
            
        if (path.hasPrefix(homeDiectory) || path.hasPrefix(bundlePath)) {
            let fileManager = FileManager.default
            let samplesFilePath = NSHomeDirectory().appending("/Documents/Files")
            let fileName = document.lastPathComponent ?? ""
            let docsFilePath = samplesFilePath + "/" + fileName
            
            if !fileManager.fileExists(atPath: samplesFilePath) {
                try? FileManager.default.createDirectory(atPath: samplesFilePath, withIntermediateDirectories: true, attributes: nil)
            }
            
            try? FileManager.default.copyItem(atPath: document.path ?? "", toPath: docsFilePath)
            
            documentPath = docsFilePath
        } else {
            success = document.startAccessingSecurityScopedResource()
        }
        
        
        
        let jsonDataParse = CPDFJSONDataParse(String: jsonString as! String)
        let configuration = jsonDataParse.configuration
        
        // Create the pdfview controller view
        pdfViewController = CPDFViewController(filePath: documentPath, password: password as? String, configuration: configuration!)
        
        navigationController = CNavigationController(rootViewController: pdfViewController)
        navigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationController.view.frame = frame
        
        plugin = CPDFViewCtrlPlugin(viewId: viewId, binaryMessenger: messenger!, controller: pdfViewController)

        super.init()
        
        // Proxy set, but not used
        pdfViewController.delegate = self
        
        navigationController.setViewControllers([pdfViewController], animated: true)
        
        if success {
            document.stopAccessingSecurityScopedResource()
        }
    }

    func view() -> UIView {
        return navigationController.view
    }
    
    // MARK: - CPDFViewBaseControllerDelete
        
    public func PDFViewBaseControllerDissmiss(_ baseControllerDelete: CPDFViewBaseController) {

    }
   
    func PDFViewBaseController(_ baseController: CPDFViewBaseController, SaveState success: Bool) {
        if success {
            plugin._methodChannel.invokeMethod("saveDocument", arguments: nil)
        }
    }
    
    func PDFViewBaseController(_ baseController: CPDFViewBaseController, currentPageIndex index: Int) {
        plugin._methodChannel.invokeMethod("onPageChanged", arguments: ["pageIndex": index])
    }

}



