import Flutter
import UIKit
import ComPDFKit
import ComPDFKit_Tools

public class CompdfkitFlutterPlugin: NSObject, FlutterPlugin, CPDFViewBaseControllerDelete {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.compdfkit.flutter.plugin", binaryMessenger: registrar.messenger())
        let instance = CompdfkitFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "sdk_version_code":
            result(CPDFKit.sharedInstance().versionString)
        case "init_sdk":
            let initInfo = call.arguments as? [String: Any]
            let key = initInfo?["key"] ?? ""
            CPDFKit.verify(withKey: key as? String)
        case "sdk_build_tag":
            result("iOS build tag:\(CPDFKit.sharedInstance().buildNumber)")
        case "openDocument":
            let initInfo = call.arguments as? [String: Any]
            let jsonString = initInfo?["configuration"] ?? ""
            _ = initInfo?["password"] ?? ""
            let path = initInfo?["document"] as? String ?? ""
            let jsonDic = readJSON(jsonString as! String)
            let configuration = parseJSON(jsonDic)
            
            if let rootViewControl = UIApplication.shared.keyWindow?.rootViewController {
                var tRootViewControl = rootViewControl
                
                if let presentedViewController = rootViewControl.presentedViewController {
                    tRootViewControl = presentedViewController
                }
                
                let pdfViewController = CPDFViewController(filePath: path, password: nil, configuration: configuration)
                let navController = CNavigationController(rootViewController: pdfViewController)
                pdfViewController.delegate = self
                navController.modalPresentationStyle = .fullScreen
                tRootViewControl.present(navController, animated: true)
            }
        case "getTemporaryDirectory":
            result(self.getTemporaryDirectory())
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Private Methods
    
    func readJSON(_ jsonFilePath: String) -> Dictionary<String, Any> {
        do {
            if let jsonData = jsonFilePath.data(using: .utf8) {
                
                let jsonDic = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] ?? [String: Any]()
                
                return jsonDic
            }
            
        } catch{
            
        }
        
        return Dictionary()
    }
    
    func parseJSON(_ jsonDic: Dictionary<String, Any>) -> CPDFConfiguration {
        let configuration = CPDFConfiguration()
        
        for (key, value) in jsonDic {
            print("Key: \(key)")
            if let innerDict = value as? [String: Any] {
                for (innerKey, innerValue) in innerDict {
                    if let innerArray = innerValue as? [Any] {
                        if innerKey == "iosRightBarAvailableActions" {
                            for (_, item) in innerArray.enumerated() {
                                if item as! String == "search" {
                                    let search = CNavBarButtonItem(viewRightBarButtonItem: .search)
                                    configuration.showRightItems.append(search)
                                } else if item as! String == "bota" {
                                    let bota = CNavBarButtonItem(viewRightBarButtonItem: .bota)
                                    configuration.showRightItems.append(bota)
                                } else if item as! String == "menu" {
                                    let more = CNavBarButtonItem(viewRightBarButtonItem: .more)
                                    configuration.showRightItems.append(more)
                                }
                            }
                        } else if innerKey == "iosLeftBarAvailableActions" {
                            for (_, item) in innerArray.enumerated() {
                                
                                if item as! String == "back" {
                                    let back = CNavBarButtonItem(viewLeftBarButtonItem: .back)
                                    configuration.showleftItems.append(back)
                                } else if item as! String == "thumbnail" {
                                    let thumbnail = CNavBarButtonItem(viewLeftBarButtonItem: .thumbnail)
                                    configuration.showleftItems.append(thumbnail)
                                }
                            }
                        } else if innerKey == "availableMenus" {
                            for (_, item) in innerArray.enumerated() {
                                if item as! String == "viewSettings" {
                                    configuration.showMoreItems.append(.setting)
                                } else if item as! String == "documentEditor" {
                                    configuration.showMoreItems.append(.pageEdit)
                                } else if item as! String == "security" {
                                    configuration.showMoreItems.append(.security)
                                } else if item as! String == "watermark" {
                                    configuration.showMoreItems.append(.watermark)
                                } else if item as! String == "documentInfo" {
                                    configuration.showMoreItems.append(.info)
                                } else if item as! String == "save" {
                                    configuration.showMoreItems.append(.save)
                                } else if item as! String == "share" {
                                    configuration.showMoreItems.append(.share)
                                } else if item as! String == "openDocument" {
                                    configuration.showMoreItems.append(.addFile)
                                }
                            }
                        }
                    } else {
                        if innerKey == "initialViewMode" {
                            if innerValue as! String == "viewer" {
                                configuration.enterToolModel = .viewer
                            } else if innerValue as! String == "annotations" {
                                configuration.enterToolModel = .annotation
                            } else if innerValue as! String == "contentEditor" {
                                configuration.enterToolModel = .edit
                            } else if innerValue as! String == "forms" {
                                configuration.enterToolModel = .form
                            } else if innerValue as! String == "digitalSignatures" {
                                configuration.enterToolModel = .signature
                            }
                        }
                    }
                }
            } else if let innerArray = value as? [Any] {
                for (index, item) in innerArray.enumerated() {
                    print("  Item \(index): \(item)")
                }
            }
        }
        
        return configuration
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
