package com.yhz.flutter_component_package

import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.common.StringCodec
import java.time.LocalDateTime
import java.util.Timer
import kotlin.concurrent.timerTask

class MainActivity : FlutterActivity() {
    private var asListener: Boolean = true
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var methodChannel: MethodChannel? = null
    private var basicMessageChannel: BasicMessageChannel<Any>? = null

    //configureFlutterEngine 当activity创建后就会调用，不会重复调用
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        createMethodChannel(flutterEngine)
        createEventChannel(flutterEngine)
        createMessageChannel(flutterEngine)

    }

    //创建消息通道
    private fun createMessageChannel(flutterEngine: FlutterEngine) {
        basicMessageChannel = BasicMessageChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "MyBasicMessageChannel",
            StandardMessageCodec.INSTANCE
        )
        basicMessageChannel?.setMessageHandler { message, reply ->
            message?.let {
                Log.d("消息通道：", it.toString())
                reply.reply("收到flutter消息")
                basicMessageSend()
            }
        }
    }

    private fun basicMessageSend() {
        Thread(kotlinx.coroutines.Runnable {
            Thread.sleep(2000)
            runOnUiThread {
                basicMessageChannel?.send(
                    "你也好：${LocalDateTime.now()}"
                ) {
                    if (it != null) {
                        Log.d("收到flutter消息返回：", it.toString())
                    }
                }
            }
        }).start()
    }

    //创建事件通道
    private fun createEventChannel(flutterEngine: FlutterEngine) {
        Log.e("createEventChannel", "createEventChannel: ")
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "MyEventChannel")
        eventChannel?.setStreamHandler(object : StreamHandler {
            //onListen调用机制 当flutter产生监听就会调用
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                Log.e("onListen", "onListen: ")
                eventSink = events
                asListener = true
                startSendTime()
            }

            //时间监听取消就会回调
            override fun onCancel(arguments: Any?) {
                asListener = false
                Log.d("事件通道：取消", "")
            }
        })
    }

    //开始发送当前时间
    private fun startSendTime() {
        Log.e("startSendTime", "startSendTime: ")
        Thread(kotlinx.coroutines.Runnable {
            while (asListener) {
                runOnUiThread {
                    eventSink?.success(LocalDateTime.now().toString())
                }
                Thread.sleep(1000)
            }
        }).start()
    }

    //创建方法通道
    private fun createMethodChannel(flutterEngine: FlutterEngine) {
        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "MyMethodChannel")
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "DeviceInfo" -> {
                    callFlutter()
//                    call.argument<String>("message")?.let { Log.d("方法通道：DeviceInfo", it) }
                    call.arguments?.let { Log.d("方法通道：DeviceInfo", it.toString()) }
                    result.success("正在获取中，3秒后返回结果")
                }
            }
        }
    }

    //调用flutter方法
    private fun callFlutter() {
        Timer().schedule(timerTask {
            runOnUiThread {
                methodChannel?.invokeMethod(
                    "DeviceInfo",
                    mutableMapOf("data" to Build.MODEL),
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            Log.d("方法通道：", "调用成功")
                        }

                        override fun error(
                            errorCode: String,
                            errorMessage: String?,
                            errorDetails: Any?
                        ) {
                            Log.d("方法通道：", "调用失败${errorMessage}")
                        }

                        override fun notImplemented() {
                            Log.d("方法通道：", "没有相关实现")
                        }
                    })
            }
        }, 3000)
    }
}
