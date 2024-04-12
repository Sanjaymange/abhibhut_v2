package com.abhibhut.Utils;

import android.annotation.TargetApi;
import android.app.AppOpsManager;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.util.Log;

@TargetApi(Build.VERSION_CODES.LOLLIPOP)
public class UsagePermissionMonitor {
        private final Context context;
        private final AppOpsManager appOpsManager;
        private final Handler handler;
        private boolean isListening;
        private Boolean lastValue;

        public UsagePermissionMonitor(Context context) {
            this.context = context;
            appOpsManager = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            handler = new Handler();
        }

        public void startListening() {
            appOpsManager.startWatchingMode(AppOpsManager.OPSTR_GET_USAGE_STATS, context.getPackageName(), usageOpListener);
            isListening = true;
        }

        public void stopListening() {
            lastValue = null;
            isListening = false;
            appOpsManager.stopWatchingMode(usageOpListener);
            handler.removeCallbacks(checkUsagePermission);
        }

        private final AppOpsManager.OnOpChangedListener usageOpListener = new AppOpsManager.OnOpChangedListener() {
            @Override
            public void onOpChanged(String op, String packageName) {
                // Android sometimes sets packageName to null
                if (packageName == null || context.getPackageName().equals(packageName)) {
                    // Android actually notifies us of changes to ops other than the one we registered for, so filtering them out
                    if (AppOpsManager.OPSTR_GET_USAGE_STATS.equals(op)) {
                        // We're not in main thread, so post to main thread queue
                        handler.post(checkUsagePermission);
                    }
                }
            }
        };

        private final Runnable checkUsagePermission = new Runnable() {
            @Override
            public void run() {
                if (isListening) {
                    int mode = 0;
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
                        mode = appOpsManager.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.getPackageName());
                    }
                    boolean enabled = mode == AppOpsManager.MODE_ALLOWED;

                    // Each change to the permission results in two callbacks instead of one.
                    // Filtering out the duplicates.
                    if (lastValue == null || lastValue != enabled) {
                        lastValue = enabled;
                        Log.i(UsagePermissionMonitor.class.getSimpleName(), "Usage permission changed: " + enabled);
                    }
                }
            }
        };

    }
