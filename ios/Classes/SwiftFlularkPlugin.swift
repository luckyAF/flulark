import Flutter
import UIKit
import LarkSSO

public class SwiftFlularkPlugin: NSObject, FlutterPlugin {
    
    
    private static var swiftFlularkChannel: FlutterMethodChannel?
    
    private static var useChallengeCode:Bool = true
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        swiftFlularkChannel = FlutterMethodChannel(name: "com.luckyaf/flulark", binaryMessenger: registrar.messenger())
        let instance = SwiftFlularkPlugin()
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: swiftFlularkChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "flu_lark_platform_version" {// 默认的实现
            
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "flu_lark_login"{// 准备登陆
            let arg = call.arguments as! Dictionary<String, Any>
            let _appid = arg["flu_lark_app_id"]
            
            if _appid is String {
                prepareLogin(_appid)
            }
        }
    }
    
    
    private func prepareLogin(appid: String) {
        LarkSSO.register(apps: [
            App(server: .feishu, appId: appid, scheme: appid)
        ])
        LarkSSO.setupLang("zh")
        let request = LKSSORequest.feishu
        request.scope = ["contact:user.employee_id:readonly", "contact:user.id:readonly"]
        request.useChallengeCode = true // 是否使用挑战码模式 默认false
        LarkSSO.send(request: request, delegate: self)
        
    }
    
}

extension SwiftFlularkPlugin:LarkSSODelegate{
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return LarkSSO.handleURL(url)
    }
    
    public func didReceive(response: SSOResponse) {
        if SwiftFlularkPlugin.useChallengeCode {
            response.safeHandleResultWithCodeVerifier(success: { (code, codeVerifier) in
                var map = ["flu_lark_msg":code]
                SwiftFlularkPlugin.swiftFlularkChannel?.invokeMethod("flu_lark_success_callback", arguments: map)
            
            }, failure: { (error) in
                var map = ["flu_lark_msg":"\(error)"]
                SwiftFlularkPlugin.swiftFlularkChannel?.invokeMethod("flu_lark_error_callback", arguments: map)
            })
        } else {
            response.safeHandleResult { (code) in
                alert(content: "Success: \(code)")
            } failure: { (error) in
                switch error.type {
                case .cancelled: break
                default:
                    alert(content: "Failure: \(error)")
                    break
                }
            }
        }
    }
}



