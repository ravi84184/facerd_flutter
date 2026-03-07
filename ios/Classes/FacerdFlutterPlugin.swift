import Flutter
import UIKit

public class FacerdPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {

    let channel = FlutterMethodChannel(name: "facerd_plugin", binaryMessenger: registrar.messenger())

    let instance = FacerdPlugin()

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if call.method == "captureFace" {

        guard let args = call.arguments as? Dictionary<String,Any>,
              let pidOptions = args["pidOptions"] as? String else {
            result(nil)
            return
        }

        let encoded = pidOptions.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let urlString = "facerd://capture?request=\(encoded)"

        if let url = URL(string: urlString) {

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                result("FACE_RD_OPENED")
            } else {
                result(FlutterError(code: "NOT_INSTALLED", message: "FaceRD not installed", details: nil))
            }
        }
    }

    if call.method == "isFaceRDInstalled" {

        if UIApplication.shared.canOpenURL(URL(string: "facerd://")!) {
            result(true)
        } else {
            result(false)
        }
    }
  }
}