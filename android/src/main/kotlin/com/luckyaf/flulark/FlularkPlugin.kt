package com.luckyaf.flulark

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.ss.android.larksso.CallBackData
import com.ss.android.larksso.IGetDataCallback
import com.ss.android.larksso.LarkSSO

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** FlularkPlugin */
class FlularkPlugin: FlutterPlugin, MethodCallHandler , ActivityAware,
        PluginRegistry.NewIntentListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var mContext: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, Constants.FLU_LARK_CHANNEL)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when(call.method){
      Constants.FLU_LARK_PLATFORM_VERSION->{
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      Constants.FLU_LARK_LOGIN -> {
        val msg = call.argument<String>(Constants.FLU_LARK_APP_ID)
        val scopeList = ArrayList<String>()
        scopeList.add("contact:user.employee_id:readonly")
        scopeList.add("contact:user.id:readonly")
        val builder = LarkSSO.Builder().setAppId(msg)
                .setServer("Feishu")
                .setLanguage("zh")
                .setChallengeMode(true)
                .setScopeList(scopeList)
                .setContext(mContext as Activity?)
        LarkSSO.inst().startSSOVerify(builder, object : IGetDataCallback {
          override fun onSuccess(callBackData: CallBackData) {
            val params = mapOf(
                    Constants.FLU_LARK_CALLBACK to callBackData.code
            )
            channel.invokeMethod(Constants.FLU_LARK_SUCCESS_CALLBACK, params)
          }

          override fun onError(callBackData: CallBackData) {
            val params = mapOf(
                    Constants.FLU_LARK_CALLBACK to "授权失败Code=${callBackData.code}"
            )
            channel.invokeMethod(Constants.FLU_LARK_ERROR_CALLBACK, params)
          }
        })
      }

    }


  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onNewIntent(intent: Intent): Boolean {
    handleIntent(intent)
    return false
  }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    handleIntent(binding.activity.intent)
  }

  override fun onDetachedFromActivity() {
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    mContext = binding.activity
    handleIntent(binding.activity.intent)
  }

  private fun handleIntent(intent: Intent) {
    LarkSSO.inst().parseIntent(mContext as Activity, intent)
  }


}
