

package  org.tamper_check

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.app.FlutterApplication
import org.acra.BuildConfig
import org.acra.config.mailSender
import org.acra.config.notification
import org.acra.data.StringFormat
import org.acra.ktx.initAcra

class MainApplication : FlutterApplication() {
    companion object {
        val TAG: String = MainApplication::class.simpleName!!
    }

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)

        if (Thread.getDefaultUncaughtExceptionHandler() == null) {
            Thread.setDefaultUncaughtExceptionHandler { t, e ->
                TAG
                Log.e(TAG, "Uncaught exception in $t: ${Log.getStackTraceString(e)}")
            }
        }

        initAcra {
            buildConfigClass = BuildConfig::class.java
            reportFormat = StringFormat.JSON
            mailSender {
                mailTo = "proninyaroslav@mail.ru"
                reportAsFile = true
            }
            notification {
                title = getString(R.string.error)
                text = getString(R.string.crash_report_summary)
                channelName = getString(R.string.android_crash_report_channel)
                tickerText = getString(R.string.error)
                sendButtonText = getString(R.string.report)
                sendWithCommentButtonText = getString(R.string.report_with_comment)
                resSendWithCommentButtonIcon = android.R.drawable.ic_menu_send
                commentPrompt = getString(R.string.crash_report_extra_info)
                sendOnClick = true
            }
        }

        disableReceivers()
    }

    /// Disable receivers requested by third party plugins
    private fun disableReceivers() {
        val r1 = ComponentName(this, com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver::class.java)
        val r2 = ComponentName(this, com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver::class.java)
        packageManager.setComponentEnabledSetting(
            r1, PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
        packageManager.setComponentEnabledSetting(
            r2, PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
    }
}
