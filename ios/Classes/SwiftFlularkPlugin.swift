import Flutter
import UIKit
@import LarkSSO

public class SwiftFlularkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.luckyaf/flulark", binaryMessenger: registrar.messenger())
    let instance = SwiftFlularkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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


    private func prepareLogin(_appid: FlutterMethodCall) {
LarkSSO.register(apps: [
  App(server: .feishu, appId: _appid, scheme: _appid)
])
LarkSSO.setupLang("zh")


    }



}
