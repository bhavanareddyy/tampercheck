
package  org.tamper_check

import  org.tamper_check.channel.SaveRefImageServiceChannel
import  org.tamper_check.channel.SaveRefImageServiceQueueChannel
import  org.tamper_check.channel.SaveRefImageServiceResultChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var saveRefImageServiceChannel: SaveRefImageServiceChannel
    private lateinit var saveRefImageServiceQueueChannel: SaveRefImageServiceQueueChannel
    private lateinit var saveRefImageServiceResultChannel: SaveRefImageServiceResultChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        saveRefImageServiceQueueChannel = SaveRefImageServiceQueueChannel();
        saveRefImageServiceResultChannel = SaveRefImageServiceResultChannel();
        saveRefImageServiceChannel = SaveRefImageServiceChannel(
            applicationContext,
            saveRefImageServiceQueueChannel,
            saveRefImageServiceResultChannel,
        )
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SaveRefImageServiceChannel.channelName,
        ).setMethodCallHandler(saveRefImageServiceChannel)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SaveRefImageServiceQueueChannel.channelName,
        ).setStreamHandler(saveRefImageServiceQueueChannel)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SaveRefImageServiceResultChannel.channelName,
        ).setStreamHandler(saveRefImageServiceResultChannel)
    }
}
