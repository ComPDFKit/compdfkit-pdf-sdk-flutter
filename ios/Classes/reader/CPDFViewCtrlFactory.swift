//
//  CPDFViewCtrlFactory.swift
//
//  Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
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
    
    private var configuration: CPDFConfiguration?
    
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
        let pageIdex = initInfo?["pageIndex"] as? Int ?? 0
        
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
            
            if !fileManager.fileExists(atPath: docsFilePath) {
                try? FileManager.default.copyItem(atPath: document.path ?? "", toPath: docsFilePath)
            }
            
            documentPath = docsFilePath
        } else {
            success = document.startAccessingSecurityScopedResource()
        }
        
        let jsonDataParse = CPDFJSONDataParse(String: jsonString as! String)
        configuration = jsonDataParse.configuration
        configuration?.defaultPageIndex = pageIdex
        
        let imageName = configuration?.watermarkMode.imageName ?? ""
        if !imageName.isEmpty {
            if FileManager.default.fileExists(atPath: imageName) {
                if let image = UIImage(contentsOfFile: imageName) {
                    configuration?.watermarkMode.image = image
                }
            } else {
                if let url = Bundle.main.findImageURL(for: imageName) {
                    if let image = UIImage(contentsOfFile: url.path) {
                        configuration?.watermarkMode.image = image
                    }
                }
            }
        }
        
        let bookmarkImageName = configuration?.bookmarkImageName ?? ""
        if !bookmarkImageName.isEmpty {
            if FileManager.default.fileExists(atPath: bookmarkImageName) {
                if let image = UIImage(contentsOfFile: bookmarkImageName) {
                    configuration?.bookmarkImage = image
                }
            } else {
                if let url = Bundle.main.findImageURL(for: bookmarkImageName) {
                    if let image = UIImage(contentsOfFile: url.path) {
                        configuration?.bookmarkImage = image
                    }
                }
            }
        }
        
        // selectTextLeftImage
        let selectTextLeftImageName = configuration?.selectTextLeftImageName ?? ""
        if !selectTextLeftImageName.isEmpty {
            if FileManager.default.fileExists(atPath: selectTextLeftImageName) {
                if let image = UIImage(contentsOfFile: selectTextLeftImageName) {
                    configuration?.selectTextLeftImage = image
                }
            } else {
                if let url = Bundle.main.findImageURL(for: selectTextLeftImageName) {
                    if let image = UIImage(contentsOfFile: url.path) {
                        configuration?.selectTextLeftImage = image
                    }
                }
            }
        }
        
        // selectTextRightImage
        let selectTextRightImageName = configuration?.selectTextRightImageName ?? ""
        if !selectTextRightImageName.isEmpty {
            if FileManager.default.fileExists(atPath: selectTextRightImageName) {
                if let image = UIImage(contentsOfFile: selectTextRightImageName) {
                    configuration?.selectTextRightImage = image
                }
            } else {
                if let url = Bundle.main.findImageURL(for: selectTextRightImageName) {
                    if let image = UIImage(contentsOfFile: url.path) {
                        configuration?.selectTextRightImage = image
                    }
                }
            }
        }
        
        // rotationAnnotationImage
        let rotationAnnotationImageName = configuration?.rotationAnnotationImageName ?? ""
        if !rotationAnnotationImageName.isEmpty {
            if FileManager.default.fileExists(atPath: rotationAnnotationImageName) {
                if let image = UIImage(contentsOfFile: rotationAnnotationImageName) {
                    configuration?.rotationAnnotationImage = image
                }
            } else {
                if let url = Bundle.main.findImageURL(for: rotationAnnotationImageName) {
                    if let image = UIImage(contentsOfFile: url.path) {
                        configuration?.rotationAnnotationImage = image
                    }
                }
            }
        }
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(annotationsOperationChangeNotification(_:)), name: NSNotification.Name(NSNotification.Name("CPDFListViewAnnotationsOperationChangeNotification").rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pageChangedNotification(_:)), name: NSNotification.Name(NSNotification.Name("CPDFViewPageChangedNotification").rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pageEditingDidChanged(_:)), name: NSNotification.Name(NSNotification.Name("CPDFPageEditingDidChangedNotification").rawValue), object: nil)
    }
    
    func view() -> UIView {
        return navigationController.view
    }
    
    deinit {
#if DEBUG
        print("====CPDFViewCtrlFlutter==deinit")
#endif
    }
    
    private func getImagePath(forResource imageName: String) -> String? {
        let fileManager = FileManager.default
        let imageExtensions = ["png", "jpg", "jpeg", "gif", "bmp"]
        
        if let resourcePath = Bundle.main.resourcePath,
           let fileList = try? fileManager.contentsOfDirectory(atPath: resourcePath) {
            for file in fileList {
                for ext in imageExtensions {
                    if file.lowercased().hasSuffix(ext) && file.lowercased().contains(imageName.lowercased()) {
                        return resourcePath + "/" + file
                    }
                }
            }
        }
        return nil
    }
    
    // MARK: - Notification
    
    @objc func annotationsOperationChangeNotification(_ notification: Notification) {
        let canUndo = pdfViewController.pdfListView?.canUndo() ?? false
        let canRedo = pdfViewController.pdfListView?.canRedo() ?? false
        
        plugin._methodChannel.invokeMethod("onAnnotationHistoryChanged", arguments: [
            "canUndo": canUndo,
            "canRedo": canRedo
        ])
    }
    
    @objc func pageChangedNotification(_ notification: Notification) {
        guard let pdfview = notification.object as? CPDFView else {
            return
        }
        let canUndo = pdfview.canEditTextUndo()
        let canRedo = pdfview.canEditTextRedo()
        let pageIndex = pdfview.currentPageIndex
        
        plugin._methodChannel.invokeMethod("onContentEditorHistoryChanged", arguments: [
            "pageIndex": pageIndex,
            "canUndo": canUndo,
            "canRedo": canRedo
        ])
    }
    
    @objc func pageEditingDidChanged(_ notification: Notification) {
        guard let page = notification.object as? CPDFPage else {
            return
        }
        
        let canUndo = pdfViewController.pdfListView?.canEditTextUndo() ?? false
        let canRedo = pdfViewController.pdfListView?.canEditTextRedo() ?? false
        let pageIndex = page.pageIndexInteger
        
        plugin._methodChannel.invokeMethod("onContentEditorHistoryChanged", arguments: [
            "pageIndex": pageIndex,
            "canUndo": canUndo,
            "canRedo": canRedo
        ])
    }
    
    // MARK: - CPDFViewBaseControllerDelete
    
    public func PDFViewBaseControllerDissmiss(_ baseControllerDelete: CPDFViewBaseController) {
        baseControllerDelete.dismiss(animated: true)
        plugin._methodChannel.invokeMethod("onIOSClickBackPressed", arguments: nil)
    }
    
    func PDFViewBaseControllerDigitalSignatureDone(_ baseController: CPDFViewBaseController) {
        
    }
    
    func PDFViewBaseController(_ baseController: CPDFViewBaseController, SaveState success: Bool) {
        if success {
            plugin._methodChannel.invokeMethod("saveDocument", arguments: nil)
        }
    }
    
    func PDFViewBaseController(_ baseController: CPDFViewBaseController, currentPageIndex index: Int) {
        plugin._methodChannel.invokeMethod("onPageChanged", arguments: ["pageIndex": index])
    }
    
    func PDFViewBaseControllerPageEditBack(_ baseController: CPDFViewBaseController) {
        plugin._methodChannel.invokeMethod("onPageEditDialogBackPress", arguments: nil)
    }
    
    func PDFViewBaseController(_ baseController: CPDFViewBaseController, HiddenState state: Bool) {
        plugin._methodChannel.invokeMethod("onFullScreenChanged", arguments: state)
    }
    
    func PDFViewBaseController(_ baseController: CPDFViewBaseController, LoadState success: Bool) {
        if success {
            self.plugin._methodChannel.invokeMethod("onDocumentIsReady", arguments: nil)
        }
    }
    
    func PDFViewBaseControllerTouchEnded(_ baseController: CPDFViewBaseController) {
        self.plugin._methodChannel.invokeMethod("onTapMainDocArea", arguments: nil)
    }
    
    func PDFViewBaseControllerAnndotationAdded(_ baseController: CPDFViewBaseController, forAnnotation annotation: CPDFAnnotation) {
        // Only parse and send data when event is subscribed
        guard plugin.subscribedEvents.contains("annotationsCreated") else { return }
        
        let page = annotation.page
        let pageUtil = CPDFPageUtil(page: page)
        pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
        
        let dict = pageUtil.getAnnotation(FormAnnotation: annotation)
        self.plugin._methodChannel.invokeMethod("annotationsCreated", arguments: dict)
    }
    
    func PDFViewBaseControllerAnndotationSelect(_ baseController: CPDFViewBaseController, forAnnotation annotation: CPDFAnnotation, isSelected: Bool) {
        let eventName = isSelected ? "annotationsSelected" : "annotationsDeselected"
        // Only parse and send data when event is subscribed
        guard plugin.subscribedEvents.contains(eventName) else { return }
        
        let page = annotation.page
        let pageUtil = CPDFPageUtil(page: page)
        pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
        
        let dict = pageUtil.getAnnotation(FormAnnotation: annotation)
        self.plugin._methodChannel.invokeMethod(eventName, arguments: dict)
    }
    
    func PDFViewBaseControllerFormFieldAdded(_ baseController: CPDFViewBaseController, forFormField formField: CPDFWidgetAnnotation) {
        // Only parse and send data when event is subscribed
        guard plugin.subscribedEvents.contains("formFieldsCreated") else { return }
        
        let page = formField.page
        let pageUtil = CPDFPageUtil(page: page)
        pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
        
        let dict = pageUtil.getForm(FormAnnotation: formField)
        self.plugin._methodChannel.invokeMethod("formFieldsCreated", arguments: dict)
    }
    
    func PDFViewBaseControllerFormFieldSelect(_ baseController: CPDFViewBaseController, forFormField formField: CPDFWidgetAnnotation, isSelected: Bool) {
        let eventName = isSelected ? "formFieldsSelected" : "formFieldsDeselected"
        // Only parse and send data when event is subscribed
        guard plugin.subscribedEvents.contains(eventName) else { return }
        
        let page = formField.page
        let pageUtil = CPDFPageUtil(page: page)
        pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
        
        let dict = pageUtil.getForm(FormAnnotation: formField)
        self.plugin._methodChannel.invokeMethod(eventName, arguments: dict)
    }
    
    func PDFViewBaseControllerEditingAreaAdded(_ baseController: CPDFViewBaseController, forEditingArea editArea: CPDFEditArea, withAttributes attributes: CEditAttributes?) {
        
    }
    
    func PDFViewBaseControllerEditingAreaSelect(_ baseController: CPDFViewBaseController, forEditingArea editArea: CPDFEditArea, isSelected: Bool) {
        let eventName = isSelected ? "editorSelectionSelected" : "editorSelectionDeselected"
        // Only parse and send data when event is subscribed
        guard plugin.subscribedEvents.contains(eventName) else { return }
        
        let page = editArea.page
        let pageUtil = CPDFPageUtil(page: page)
        pageUtil.pdfView = baseController.pdfListView
        pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
        
        let dict = pageUtil.getEditArea(FromEditArea: editArea)
        self.plugin._methodChannel.invokeMethod(eventName, arguments: dict)
    }
    
    func PDFViewBaseControllerAutoShowAnnotationPicker(_ baseController: CPDFViewBaseController, forAnnotationMode annotationMode: CPDFViewAnnotationMode, forAnnotation annotation: CPDFAnnotation?) {
        if annotationMode == .stamp {
            self.plugin._methodChannel.invokeMethod("onAnnotationCreationPrepared", arguments: ["type": "stamp"])
        } else if annotationMode == .signature {
            self.plugin._methodChannel.invokeMethod("onAnnotationCreationPrepared", arguments: ["type": "signature"])
        } else if annotationMode == .image {
            self.plugin._methodChannel.invokeMethod("onAnnotationCreationPrepared", arguments: ["type": "pictures"])
        } else if annotationMode == .link {
            if let linkAnnotation = annotation as? CPDFLinkAnnotation {
                let page = linkAnnotation.page
                let pageUtil = CPDFPageUtil(page: page)
                pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
                let dict = pageUtil.getAnnotation(FormAnnotation: linkAnnotation)
                self.plugin._methodChannel.invokeMethod("onAnnotationCreationPrepared", arguments: ["type": "link", "annotation": dict])
            }
        }
    }
    
    func PDFViewBaseControllerAutoShowFormPicker(_ baseController: CPDFViewBaseController, forAnnotationMode annotationMode: CPDFViewAnnotationMode, forAnnotation annotation: CPDFWidgetAnnotation?) {
        
    }
    
    func PDFViewBaseControllerHandleCustomMenuAction(_ baseController: CPDFViewBaseController, fronView view: Any, payload: [String : Any]) {
        if let CPDFAnnotation = payload["annotation"] as? CPDFAnnotation {
            let page = CPDFAnnotation.page
            let pageUtil = CPDFPageUtil(page: page)
            pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
            let dict = pageUtil.getAnnotation(FormAnnotation: CPDFAnnotation)
            var newPayload = payload
            newPayload["annotation"] = dict
            self.plugin._methodChannel.invokeMethod("onCustomContextMenuItemTapped", arguments: newPayload)
            return
        } else if let CPDFWidgetAnnotation = payload["widget"] as? CPDFWidgetAnnotation {
            let page = CPDFWidgetAnnotation.page
            let pageUtil = CPDFPageUtil(page: page)
            pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
            let dict = pageUtil.getForm(FormAnnotation: CPDFWidgetAnnotation)
            var newPayload = payload
            newPayload["widget"] = dict
            self.plugin._methodChannel.invokeMethod("onCustomContextMenuItemTapped", arguments: newPayload)
            return
        } else if let editArea = payload["editArea"] as? CPDFEditArea {
            let page = editArea.page
            let pageUtil = CPDFPageUtil(page: page)
            pageUtil.pdfView = baseController.pdfListView
            pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
            var dict = pageUtil.getEditArea(FromEditArea: editArea)
            if let selectString = self.pdfViewController.pdfListView?.editingSelectionString() {
                dict["text"] = selectString
            }
            var newPayload = payload
            newPayload["editArea"] = dict
            self.plugin._methodChannel.invokeMethod("onCustomContextMenuItemTapped", arguments: newPayload)
            return
        } else if let image = payload["image"] as? UIImage {
            var newPayload = payload
            let data: Data = image.jpegData(compressionQuality: 0.85)!
            newPayload["image"] = data
            self.plugin._methodChannel.invokeMethod("onCustomContextMenuItemTapped", arguments: newPayload)
        } else {
            self.plugin._methodChannel.invokeMethod("onCustomContextMenuItemTapped", arguments: payload)
        }
    }
    
    func PDFViewBaseControllerHandleCustomToolbarAction(_ baseController: CPDFViewBaseController, fronView view: Any, payload: [String : Any]) {
        if let value = payload["identifier"] {
            self.plugin._methodChannel.invokeMethod("onCustomToolbarItemTapped", arguments: value)
        }
    }
    
    func PDFViewBaseControllerInterceptAnnotationDoAction(_ baseController: CPDFViewBaseController, forAnnotation annotation:CPDFAnnotation?) {
        if annotation == nil {
            return
        }
        let page = annotation?.page
        let pageUtil = CPDFPageUtil(page: page)
        pageUtil.pageIndex = Int(page?.pageIndexInteger ?? 0)
        let dict = pageUtil.getAnnotation(FormAnnotation: annotation!)
        self.plugin._methodChannel.invokeMethod("onInterceptAnnotationAction", arguments: dict)
    }
    
    
    
}



