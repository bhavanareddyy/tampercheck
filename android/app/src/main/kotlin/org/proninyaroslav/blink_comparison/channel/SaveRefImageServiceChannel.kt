

package  org.tamper_check.channel

import android.content.Context
import android.content.Intent
import android.os.Build
import  org.tamper_check.isServiceRunning
import  org.tamper_check.service.SaveRefImageService
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.*

open class SaveRefImageServiceChannel(
    private val appContext: Context,
    private val queueChannel: SaveRefImageServiceQueueChannel,
    private val resultChannel: SaveRefImageServiceResultChannel,
) : MethodChannel.MethodCallHandler {
    companion object {
        const val channelName = " org.tamper_check/save_ref_image_service"
    }

    object Methods {
        const val start = "start"
        const val stop = "stop"
        const val isRunning = "isRunning"
        const val pushQueue = "pushQueue"
        const val getAllInProgress = "getAllInProgress"
        const val sendResult = "sendResult"
    }

    object Arguments {
        const val callbackHandle = "callbackHandle"
        const val notificationTitle = "notificationTitle"
        const val notificationChannelName = "notificationChannelName"
        const val saveImageRequest = "saveImageRequest"
        const val saveImageResult = "saveImageResult"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = if (call.arguments == null) null else JSONObject(call.arguments as Map<*, *>)
        when (call.method) {
            Methods.start -> {
                val i = Intent(appContext, SaveRefImageService::class.java)
                    .apply {
                        action = SaveRefImageService.actionStart
                        putExtra(
                            SaveRefImageService.tagCallbackHandle,
                            args?.getLong(Arguments.callbackHandle)
                        )
                        putExtra(
                            SaveRefImageService.tagNotificationChannelName,
                            args?.getString(Arguments.notificationChannelName)
                        )
                        putExtra(
                            SaveRefImageService.tagNotificationTitle,
                            args?.getString(Arguments.notificationTitle)
                        )
                    }
                startService(i)
                result.success(null)
            }
            Methods.stop -> {
                val i = Intent(appContext, SaveRefImageService::class.java)
                    .apply {
                        action = SaveRefImageService.actionStop
                    }
                startService(i)
                result.success(null)
            }
            Methods.isRunning -> {
                result.success(appContext.isServiceRunning(SaveRefImageService::class.java))
            }
            Methods.pushQueue -> {
                args?.let { queueChannel.push(it.toString()) }
                result.success(null)
            }
            Methods.getAllInProgress -> {
                result.success(queueChannel.getAllInProgress())
            }
            Methods.sendResult -> {
                args?.let {
                    queueChannel.onCompleted(
                        it.getJSONObject(Arguments.saveImageRequest).toString()
                    )
                    resultChannel.send(
                        it.getJSONObject(Arguments.saveImageResult).toString()
                    )
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun startService(i: Intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            appContext.startForegroundService(i)
        } else {
            appContext.startService(i)
        }
    }
}

open class SaveRefImageServiceQueueChannel : EventChannel.StreamHandler {
    companion object {
        const val channelName = " org.tamper_check/save_ref_image_service/queue"
        val queue = LinkedList<String>()
        var currentImagesInProgress = mutableSetOf<String>()
        var eventSink: EventChannel.EventSink? = null
    }

    object Methods {
        const val observeQueue = "observeQueue"
    }

    open fun push(request: String) {
        if (eventSink?.sendEvent(request) != true) {
            queue.push(request)
        }
    }

    private fun EventChannel.EventSink.sendEvent(request: String): Boolean {
        currentImagesInProgress.add(request)
        success(request)
        return true
    }

    open fun getAllInProgress(): List<String> = queue.toMutableList().apply {
        addAll(currentImagesInProgress)
    }

    open fun onCompleted(request: String) {
        currentImagesInProgress.remove(request)
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        when (val method = arguments as String?) {
            Methods.observeQueue -> {
                SaveRefImageServiceQueueChannel.eventSink = eventSink
                while (queue.isNotEmpty()) {
                    eventSink?.sendEvent(queue.pop())
                }
            }
            else -> {
                eventSink?.apply {
                    error("1", "Unknown method: $method", null)
                    endOfStream()
                }
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}

open class SaveRefImageServiceResultChannel : EventChannel.StreamHandler {
    companion object {
        const val channelName = " org.tamper_check/save_ref_image_service/result"
        var eventSinkList: MutableList<EventChannel.EventSink?> = mutableListOf()
    }

    object Methods {
        const val observeResult = "observeResult"
    }

    open fun send(result: String) {
        eventSinkList.forEach { it?.success(result) }
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        when (val method = arguments as String?) {
            Methods.observeResult -> eventSinkList.add(eventSink)
            else -> {
                eventSink?.apply {
                    error("1", "Unknown method: $method", null)
                    endOfStream()
                }
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSinkList.removeLastOrNull()
    }
}
