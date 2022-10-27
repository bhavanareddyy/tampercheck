
package  org.tamper_check

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

class AppNotificationManager(private val appContext: Context) {
    private val foregroundNotifyChanId = " org.tamper_check.FOREGROUND_NOTIFY_CHAN"

    private val notifyManager: NotificationManager =
        appContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager

    fun buildForegroundNotify(channelName: String, title: String?): Notification {
        buildForegroundChannel(channelName)

        val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }

        val startupPendingIntent = Intent(appContext, MainActivity::class.java)
            .apply {
                action = Intent.ACTION_MAIN
                addCategory(Intent.CATEGORY_LAUNCHER)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            }
            .let { intent ->
                PendingIntent.getActivity(
                    appContext,
                    0,
                    intent,
                    flag
                )
            }

        val notify = NotificationCompat.Builder(
            appContext,
            foregroundNotifyChanId
        ).apply {
            setSmallIcon(R.drawable.ic_app_notification)
            setContentTitle(title)
            setContentIntent(startupPendingIntent)
            setWhen(System.currentTimeMillis())
            setCategory(Notification.CATEGORY_PROGRESS)
        }

        return notify.build()
    }

    private fun buildForegroundChannel(name: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }
        if (notifyManager.getNotificationChannel(foregroundNotifyChanId) != null) {
            return
        }
        val foregroundChan = NotificationChannel(
            foregroundNotifyChanId,
            name,
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            setShowBadge(false)
        }

        notifyManager.createNotificationChannel(foregroundChan);
    }
}
