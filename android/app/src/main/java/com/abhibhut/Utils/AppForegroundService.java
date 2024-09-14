package com.abhibhut.Utils;
import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

/**
 * This class is created to prevent termination of ACCESSIBILITY SERVICE by the system
 * as it was noticed that even though app was having accessibility permission after some time
 * accessibility service wasn't working and the most speculated reason was termination by system
 * as per device policies.
 * With the help of ForegroundSerice we can restart the Accessibility service
 * if it gets terminated by the system. Also ForegroundServices have less chances of system
 * termination , hence this approach is accepted
 *
 * @author Sanjay_Bhanushali
 * @version 1.0
 * @date 22-08-2024
 */

public class AppForegroundService extends Service {

    private static final String CHANNEL_ID = "ForegroundServiceChannel";
    private static final int NOTIFICATION_ID = 1;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("Foreground_service","entered into foreground service on create method");
        createNotificationChannel();
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Focused mode ON")
                .setContentText("You are protected from distractions")
                //commenting below icon part , include that in future
                //.setSmallIcon(R.drawable.ic_notification) // replace with your own icon
                .build();

        startForeground(NOTIFICATION_ID, notification);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Intent accessibilityIntent = new Intent(this, AccessibilityUtil.class);
        startService(accessibilityIntent);
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // Cleanup code if needed
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null; // Not a bound service
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "Foreground Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }
}