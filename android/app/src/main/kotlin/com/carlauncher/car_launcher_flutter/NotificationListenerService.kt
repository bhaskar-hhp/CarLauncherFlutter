package com.carlauncher.car_launcher_flutter

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification

class NotificationListenerService : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification?) { }
    override fun onNotificationRemoved(sbn: StatusBarNotification?) { }
}
