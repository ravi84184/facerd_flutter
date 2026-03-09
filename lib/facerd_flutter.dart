import 'dart:async';
import 'package:flutter/services.dart';

export 'src/rd_detector.dart';

class FaceRDPlugin {
  static const MethodChannel _channel = MethodChannel('facerd_plugin');

  /// Capture face using FaceRD
  static Future<String?> captureFace(String pidOptions) async {
    final result = await _channel.invokeMethod<String>('captureFace', {
      "pidOptions": pidOptions,
    });
    return result;
  }
}
