import Flutter
import UIKit
import ComPDFKit
import ComPDFKit_Tools

public class CompdfkitFlutterPlugin: NSObject, FlutterPlugin, CPDFViewBaseControllerDelete {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.compdfkit.flutter.plugin", binaryMessenger: registrar.messenger())
        let instance = CompdfkitFlutterPlugin()
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
        case "init_sdk_keys":
            let initInfo = call.arguments as? [String: Any]
            let key = initInfo?["iosOnlineLicense"] ?? ""
            CPDFKit.verify(withOnlineLicense: key as? String) { code, message in
                print("Code: \(code), Message:\(String(describing: message))")
            }
        case "sdk_build_tag":
            result("iOS build tag:\(CPDFKit.sharedInstance().buildNumber)")
        case "open_document":
            let initInfo = call.arguments as? [String: Any]
            let jsonString = initInfo?["configuration"] ?? ""
            _ = initInfo?["password"] ?? ""
            let path = initInfo?["document"] as? String ?? ""
            let document = NSURL(fileURLWithPath: path)

            let fileManager = FileManager.default
            let samplesFilePath = NSHomeDirectory().appending("/Documents/Files")
            let fileName = document.lastPathComponent ?? ""
            let docsFilePath = samplesFilePath + "/" + fileName

            if !fileManager.fileExists(atPath: samplesFilePath) {
                try? FileManager.default.createDirectory(atPath: samplesFilePath, withIntermediateDirectories: true, attributes: nil)
            }

            try? FileManager.default.copyItem(atPath: document.path ?? "", toPath: docsFilePath)

            let jsonDataParse = CPDFJSONDataParse(String: jsonString as! String)
            guard let configuration = jsonDataParse.configuration else { return }
            if let rootViewControl = UIApplication.shared.keyWindow?.rootViewController {
                var tRootViewControl = rootViewControl

                if let presentedViewController = rootViewControl.presentedViewController {
                    tRootViewControl = presentedViewController
                }

                let pdfViewController = CPDFViewController(filePath: docsFilePath, password: nil, configuration: configuration)
                let navController = CNavigationController(rootViewController: pdfViewController)
                pdfViewController.delegate = self
                navController.modalPresentationStyle = .fullScreen
                tRootViewControl.present(navController, animated: true)
            }
        case "get_temporary_directory":
            result(self.getTemporaryDirectory())
            
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
    
}
