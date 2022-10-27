

package  org.tamper_check

import android.app.ActivityManager
import android.content.Context

@Suppress("DEPRECATION") // Deprecated for third party Services.
fun Context.isServiceRunning(serviceClass: Class<*>): Boolean {
    val manager = this.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
    return manager.getRunningServices(Integer.MAX_VALUE).any {
        it.service.className == serviceClass.name
    }
}
