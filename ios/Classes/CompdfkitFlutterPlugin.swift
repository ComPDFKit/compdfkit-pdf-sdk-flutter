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

public class CompdfkitFlutterPlugin: NSObject, FlutterPlugin, CPDFViewBaseControllerDelete, UIDocumentPickerDelegate {

    public var messager : FlutterBinaryMessenger?
    
    private var _reuslt: FlutterResult?
    
    private var pdfViewController: CPDFViewController?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel.init(name: "com.compdfkit.flutter.plugin", binaryMessenger: registrar.messenger())

        let instance = CompdfkitFlutterPlugin()
        instance.messager = registrar.messenger()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let factory = CPDFViewCtrlFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "com.compdfkit.flutter.ui.pdfviewer")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "sdk_version_code":
            result(CPDFKit.sharedInstance().versionNumber)
        case "init_sdk":
            let initInfo = call.arguments as? [String: Any]
            let key = initInfo?["key"] ?? ""
            let code = CPDFKit.verify(withKey: key as? String)
            print("Code \(code)")
            result(nil)
        case "init_sdk_keys":
            let initInfo = call.arguments as? [String: Any]
            let key = initInfo?["iosOnlineLicense"] ?? ""
            CPDFKit.verify(withOnlineLicense: key as? String) { code, message in
                print("Code: \(code), Message:\(String(describing: message))")
                result(nil)
            }
        case "sdk_build_tag":
            result("iOS build tag:\(CPDFKit.sharedInstance().buildNumber)")
        case "open_document":
            let initInfo = call.arguments as? [String: Any]
            let jsonString = initInfo?["configuration"] ?? ""
            _ = initInfo?["password"] ?? ""
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
                
                if !fileManager.fileExists(atPath: docsFilePath) {
                    try? FileManager.default.copyItem(atPath: document.path ?? "", toPath: docsFilePath)
                }
                
                documentPath = docsFilePath
            } else {
                success = document.startAccessingSecurityScopedResource()
            }
            
        
            let jsonDataParse = CPDFJSONDataParse(String: jsonString as? String ?? "")
            guard let configuration = jsonDataParse.configuration else { return }
            if let rootViewControl = UIApplication.shared.keyWindow?.rootViewController {
                var tRootViewControl = rootViewControl
                
                if let presentedViewController = rootViewControl.presentedViewController {
                    tRootViewControl = presentedViewController
                }
                
                pdfViewController = CPDFViewController(filePath: documentPath, password: nil, configuration: configuration)
                let navController = CNavigationController(rootViewController: pdfViewController!)
                pdfViewController?.delegate = self
                navController.modalPresentationStyle = .fullScreen
                tRootViewControl.present(navController, animated: true)
            }
            
            if success {
                document.stopAccessingSecurityScopedResource()
            }
            result(nil)
        case "get_temporary_directory":
            result(self.getTemporaryDirectory())
            
        case "pick_file":
            let documentTypes = ["com.adobe.pdf"]
            let documentPickerViewController = UIDocumentPickerViewController(documentTypes: documentTypes, in: .open)
            documentPickerViewController.delegate = self
            UIApplication.presentedViewController()?.present(documentPickerViewController, animated: true, completion: nil)
            _reuslt = result
        case "remove_sign_file_list":
            CSignatureManager.sharedManager.removeAllSignatures()
            result(true)
        case "set_import_font_directory":
            let initInfo = call.arguments as? [String: Any]
    
            let dirPath = initInfo?["dir_path"] as? String ?? ""
        
            let addSysFont = initInfo?["add_sys_font"] as? Bool ?? true
            
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationPath = documentDirectory.appendingPathComponent("Font")

            do {
                if fileManager.fileExists(atPath: destinationPath.path) {
                    try fileManager.removeItem(at: destinationPath)
                }

                try fileManager.copyItem(atPath: dirPath, toPath: destinationPath.path)
                CPDFFont.setImportDir(destinationPath.path, isContainSysFont: addSysFont)
            } catch {
                print("Error copying Font directory: \(error)")
            }
            result(true)
        case "create_document_plugin":
            let uId = call.arguments as? String ?? "";
            var documentPlugin = CPDFDocumentPlugin(uid: uId, binaryMessager: self.messager!)
            result(true)
            break;
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func getTemporaryDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return paths.first ?? ""
    }
    
    // MARK: - CPDFViewBaseControllerDelete
    
    public func PDFViewBaseControllerDissmiss(_ baseControllerDelete: CPDFViewBaseController) {
        baseControllerDelete.dismiss(animated: true)
    }
    
    // MARK: - UIDocumentPickerDelegate
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileUrlAuthozied = urls.first?.startAccessingSecurityScopedResource() ?? false
        if fileUrlAuthozied {
            let filePath = urls.first?.path ?? ""
            _reuslt?(filePath)
        }
    }
    
}
