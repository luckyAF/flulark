library flulark;

import 'package:flulark/src/constants.dart';
import 'package:flutter/services.dart';

typedef FluLarkLoginCallBack = void Function(String code);

class Flulark {
  static MethodChannel? _fluLarkChannel;
  static FluLarkLoginCallBack? _fluLarkSuccessCallBack;
  static FluLarkLoginCallBack? _fluLarkErrorCallBack;

  /// 初始化
  static void init(String appId, String scheme) {
    if (_fluLarkChannel == null) {
      _fluLarkChannel = const MethodChannel(Constants.FLU_LARK_CHANNEL);
      _fluLarkChannel!.setMethodCallHandler((call) async {
        switch (call.method) {
          // 成功
          case Constants.FLU_LARK_SUCCESS_CALLBACK:
            String msg = call.arguments[Constants.FLU_LARK_CALLBACK];
            _fluLarkSuccessCallBack!(msg);
            break;
          // 失败
          case Constants.FLU_LARK_ERROR_CALLBACK:
            String msg = call.arguments[Constants.FLU_LARK_CALLBACK];
            if (_fluLarkErrorCallBack != null) {
              _fluLarkErrorCallBack!(msg);
            }
            break;
        }
      });
      _fluLarkChannel?.invokeMethod(Constants.FLU_LARK_REGISTER, {
        Constants.FLU_LARK_APP_ID: appId,
        Constants.FLU_LARK_APP_SCHEME: scheme
      });
    }
  }

  /// 获取飞书的登陆code
  static void getLarkLoginCode(Function(String code) callback,
      {Function(String code)? errorCallback, bool? mode}) {
    _fluLarkSuccessCallBack = callback;
    _fluLarkErrorCallBack = errorCallback;
    _fluLarkChannel?.invokeMethod(Constants.FLU_LARK_LOGIN,
        {Constants.FLU_LARK_CHALLENGE_MODE: mode ?? true});
  }

  static Future<String?> getPlatformVersion() async {
    final String? version = await _fluLarkChannel
        ?.invokeMethod(Constants.FLU_LARK_PLATFORM_VERSION);
    return version;
  }
}
