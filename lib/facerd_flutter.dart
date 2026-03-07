import 'dart:async';
import 'package:flutter/services.dart';

class FaceRDPlugin {
  static const MethodChannel _channel = MethodChannel('facerd_plugin');

  /// Capture face using FaceRD
  static Future<String?> captureFace(String pidOptions) async {
    final result = await _channel.invokeMethod<String>('captureFace', {
      "pidOptions": pidOptions,
    });
    return result;
  }

  /// Check if FaceRD is installed
  static Future<bool> isFaceRDInstalled() async {
    final installed = await _channel.invokeMethod<bool>('isFaceRDInstalled');
    return installed ?? false;
  }
}
