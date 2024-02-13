package com.abhibhut.Utils;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Build;

import java.util.ArrayList;
import java.util.List;

/*This class checks for all the apps installed by the user which are having browsing capabilities*/

public class BrowserUtils {

    public static List<String> getInstalledBrowsers(Context context) {
        List<String> installedBrowsers = new ArrayList<>();

        // Create an intent to filter for web browsers
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse("https://www.google.com"));
        PackageManager packageManager = context.getPackageManager();

        // Query the package manager for activities that can handle the intent
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // Check whether I need to pass PackageManager.ANY_FLAG STRING CONSTANT or 0 will work
            packageManager.queryIntentActivities(intent,
                    PackageManager.ResolveInfoFlags.of(0));
        } else {

            packageManager.queryIntentActivities(intent,0);
        }

        List<ResolveInfo> activities = packageManager.queryIntentActivities(intent, 0);

        // Iterate over the resolved activities and extract their package names
        for (ResolveInfo resolveInfo : activities) {
            String packageName = resolveInfo.activityInfo.packageName;
            installedBrowsers.add(packageName);
        }

        return installedBrowsers;
    }


}
