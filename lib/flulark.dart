
import 'dart:async';

import 'package:flutter/services.dart';

class Flulark {
  static const MethodChannel _channel = MethodChannel('flulark');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
