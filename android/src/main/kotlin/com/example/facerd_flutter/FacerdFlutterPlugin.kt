package com.example.facerd_flutter

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class FacerdFlutterPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var resultData: MethodChannel.Result? = null

    private val CAPTURE_REQUEST = 1001

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "facerd_plugin")
        channel.setMethodCallHandler(this)
    }

    // 🔴 THIS WAS MISSING
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {

            "captureFace" -> {

                val pidOptions = call.argument<String>("pidOptions")

                val intent = Intent("in.gov.uidai.rdservice.face.CAPTURE")
                intent.putExtra("request", pidOptions)

                resultData = result
                activity?.startActivityForResult(intent, CAPTURE_REQUEST)
            }

            "isFaceRDInstalled" -> {

                try {
                    activity?.packageManager?.getPackageInfo("in.gov.uidai.facerd", 0)
                    result.success(true)
                } catch (e: Exception) {
                    result.success(false)
                }
            }

            else -> result.notImplemented()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {

        activity = binding.activity

        binding.addActivityResultListener { requestCode, resultCode, data ->

            if (requestCode == CAPTURE_REQUEST) {

                val response = data?.getStringExtra("response")
                resultData?.success(response)

                return@addActivityResultListener true
            }

            false
        }
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }
}