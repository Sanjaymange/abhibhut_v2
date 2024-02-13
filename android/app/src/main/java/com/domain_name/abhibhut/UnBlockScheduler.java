package com.domain_name.abhibhut;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

/*This is just the psudo code , and it is under testing*/
public class UnBlockScheduler {

    public static void scheduleAlarm(Context context, long alarmTimeMillis) {
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

        Intent intent = new Intent(context, AllBroadcastReceiver.class); // Or your service or activity
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        // Set the alarm to trigger at the specified time
        if (alarmManager != null) {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, alarmTimeMillis, pendingIntent);
        }
    }
}
