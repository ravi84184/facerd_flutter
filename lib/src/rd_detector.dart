import 'package:flutter/services.dart';

class RDDetector {
  static const MethodChannel _channel = MethodChannel('facerd_plugin');

  /// Check if FaceRD is installed
  static Future<bool> isFaceRDInstalled() async {
    final result = await _channel.invokeMethod<bool>('isFaceRDInstalled');
    return result ?? false;
  }

  /// Check RD device availability
  static Future<RDDeviceStatus> checkFaceRD() async {
    final installed = await isFaceRDInstalled();

    if (!installed) {
      return RDDeviceStatus.notInstalled;
    }

    return RDDeviceStatus.ready;
  }
}

enum RDDeviceStatus { ready, notInstalled }
