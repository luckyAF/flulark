import Flutter
import UIKit
import LarkSSO

public class SwiftFlularkPlugin: NSObject, FlutterPlugin {
    
      public static let FLU_LARK_CHANNEL = "com.luckyaf/flulark";


      public static let FLU_LARK_REGISTER = "flu_lark_register";


      public static let FLU_LARK_LOGIN = "flu_lark_login";

      public static let FLU_LARK_PLATFORM_VERSION = "flu_lark_platform_version";

      public static let FLU_LARK_SUCCESS_CALLBACK = "flu_lark_success_callback";

      public static let FLU_LARK_ERROR_CALLBACK = "flu_lark_error_callback";


      public static let FLU_LARK_SERVER = "flu_lark_server";


      public static let FLU_LARK_APP_ID = "flu_lark_app_id";

      public static let FLU_LARK_APP_SCHEME = "flu_lark_app_scheme";

      public static let  FLU_LARK_CHALLENGE_MODE = "flu_lark_challenge_mode"

      public static let FLU_LARK_CALLBACK = "flu_lark_msg";


    public static var swiftFlularkChannel: FlutterMethodChannel?
    
   public  static var useChallengeCode:Bool = true

    var flutterViewController: FlularkFlutterViewController

    init(flutterViewController: FlularkFlutterViewController) {
        self.flutterViewController = flutterViewController
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: SwiftFlularkPlugin.FLU_LARK_CHANNEL, binaryMessenger: registrar.messenger())
        let flutterViewController = UIApplication.shared.delegate?.window?!.rootViewController as! FlularkFlutterViewController
        let instance = SwiftFlularkPlugin(flutterViewController:flutterViewController)
        swiftFlularkChannel = channel
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)

    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == SwiftFlularkPlugin.FLU_LARK_PLATFORM_VERSION {// 默认的实现
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == SwiftFlularkPlugin.FLU_LARK_REGISTER{// 准备注册
            let arg = call.arguments as! Dictionary<String, Any>
            let _server = arg[SwiftFlularkPlugin.FLU_LARK_SERVER] as? Int ?? 0
            let _appid = arg[SwiftFlularkPlugin.FLU_LARK_APP_ID] as? String ?? ""
            let _appScheme = arg[SwiftFlularkPlugin.FLU_LARK_APP_SCHEME] as? String ?? ""
            registerIdAndScheme(server:_server,appid:_appid,scheme:_appScheme)

        } else if call.method == SwiftFlularkPlugin.FLU_LARK_PLATFORM_VERSION{// 准备登陆
           let arg = call.arguments as! Dictionary<String, Any>
           let mode = arg[SwiftFlularkPlugin.FLU_LARK_CHALLENGE_MODE] as? Bool ?? true
           prepareLogin(challengeCode:mode)

        }
    }


    private func registerIdAndScheme(server:Int,appid: String,scheme:String) {
            if server == 0 {
            LarkSSO.register(apps: [
                            App(server: .feishu, appId: appid, scheme: scheme)
                        ])
            }else{
            LarkSSO.register(apps: [
                            App(server: .lark, appId: appid, scheme: scheme)
                        ])
            }

            LarkSSO.setupLang("zh")
        }

    private func prepareLogin(challengeCode:Bool) {
        let request = SSORequest.feishu
        request.scope = ["contact:user.employee_id:readonly", "contact:user.id:readonly"]
        request.useChallengeCode = challengeCode // 是否使用挑战码模式 默认false
        SwiftFlularkPlugin.useChallengeCode = challengeCode
        LarkSSO.send(request: request,viewController:flutterViewController, delegate: flutterViewController)

    }



}

extension SwiftFlularkPlugin {
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return LarkSSO.handleURL(url)
    }
}




