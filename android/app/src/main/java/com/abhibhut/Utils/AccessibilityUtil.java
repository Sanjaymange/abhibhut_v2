package com.abhibhut.Utils;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.provider.Settings;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.os.Process;
import com.domain_name.abhibhut.AppData;
import com.domain_name.abhibhut.PornBlock;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/* This is now become a driver class to perform activities in AppBlock and PornBlock */
public class AccessibilityUtil extends AccessibilityService {

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        /* Stop the Worker (if running) which is creating an intent every 7 seconds to navigate the user to Settings */
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {

        String pkg_nm = (String) event.getPackageName();

        /* Although we have set Package names for which we are tracking window state change , but as we have broswer
         * packages as well , so we need to ensure that a browser is not being blocked unless it is tagged by the user
         * to block it */

        if( (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED)||
        (event.getEventType() == AccessibilityEvent.TYPE_WINDOWS_CHANGED)){
            Map<String , Object> blocked_pkgs = AppData.getBlockedPkgs(getApplicationContext());

            /*Adding youtube as the default app as of now and placing any dummy value in object*/
            blocked_pkgs.put("com.google.android.youtube",001);
            if(blocked_pkgs.containsKey(pkg_nm)) {
                /*This method is implemented in AppBlock , but for testing purpose it was included here and below this code*/
                disableAppLaunch();
            }
            if (event.getEventType() == AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED) {

                CharSequence text = (CharSequence) event.getText();

                if (text != null && PornBlock.containsPornographicContent(text.toString())) {
                    new PornBlock().porn_block();
                }
            }
        }
    }


    /*Check in settings whether accessibility service is added or not*/
    /* Commented is the older version , following would be the newer version */
    /*public static boolean isAccessibilityServiceEnabled(Context context, Class<?> accessibilityService) {
        int accessibilityEnabled = 0;
        final String service = context.getPackageName() + "/" + accessibilityService.getName();
        try {
            accessibilityEnabled = Settings.Secure.getInt(
                    context.getApplicationContext().getContentResolver(),
                    Settings.Secure.ACCESSIBILITY_ENABLED);
        } catch (Settings.SettingNotFoundException e) {
            e.printStackTrace();
        }

        TextUtils.SimpleStringSplitter splitter = new TextUtils.SimpleStringSplitter(':');
        if (accessibilityEnabled == 1) {
            String settingValue = Settings.Secure.getString(
                    context.getApplicationContext().getContentResolver(),
                    Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
            if (settingValue != null) {
                splitter.setString(settingValue);
                while (splitter.hasNext()) {
                    String accessibilityServiceInfo = splitter.next();
                    if (accessibilityServiceInfo.equalsIgnoreCase(service)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }*/

    //method to check whether the accessibility is enabled or not
    public static boolean isAccessibilityServiceEnabled(Context context) {
    AppOpsManager appOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
    int mode = AppOpsManager.MODE_ERRORED;

        if (appOps != null) {
        mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_WRITE_SETTINGS, Process.myUid(), context.getPackageName());
    }

        if (mode == AppOpsManager.MODE_ALLOWED) {
        Log.d("UTILS", "Accessibility permission is granted");
        return true;
    }

        Log.d("UTILS", "Accessibility permission is not granted");
        return false;
}

    /*Following function is for checking accessibility access*/
    public static void grantAccessibilityPermission(Context context) {
            try {
                Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            } catch (Exception e) {
                Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            }
    }

    /*This function will add package names from accessibility service config*/
    public void addPackageNameDynamically(String[] packageName) {
        AccessibilityServiceInfo info = getServiceInfo();
        String[] existingPackageNames = info.packageNames;
        // Create a new array with the additional package name
        String[] newPackageNames = new String[existingPackageNames.length + packageName.length];
        System.arraycopy(existingPackageNames, 0, newPackageNames, 0, existingPackageNames.length);
        System.arraycopy(packageName, 0, newPackageNames, 0, packageName.length);
        // Update the service configuration
        info.packageNames = newPackageNames;
        setServiceInfo(info);
    }
    // Method to dynamically remove a package name from the service configuration

    public void removePackageNameDynamically(List<String> packageNames) {

        AccessibilityServiceInfo info = getServiceInfo();
        String[] existingPackageNames = info.packageNames;

        List<String> newPackageNamesList = new ArrayList<>(Arrays.asList(existingPackageNames));

        boolean contains_package = false;

        for (String packageName : packageNames) {
            if (newPackageNamesList.remove(packageName)) {
                contains_package = true;
            }
        }
        // If found, create a new array without the specified package name
        if (contains_package) {
            // Convert the list back to an array
            String[] newPackageNames = newPackageNamesList.toArray(new String[0]);
            info.packageNames = newPackageNames;
            setServiceInfo(info);
        }
    }

    @Override
    public void onInterrupt() {
        /* Add a logic to raise an alert every 7 seconds if accessibility service is turned off , turn on abhibhut app
         * and show intent which navigates to Accessibility service Setting page (Use openAccessibilitySettings method in
         * AccessibilityUtil.java class . This should be only done for those
         * users who have apps which should be blocked */
    }

    /*This method returns the user to home page*/
    public void disableAppLaunch() {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

}
