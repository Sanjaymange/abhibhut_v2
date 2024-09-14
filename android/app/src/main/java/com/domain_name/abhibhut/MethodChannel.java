package com.domain_name.abhibhut;
import android.app.ActivityManager;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.abhibhut.Utils.AccessibilityUtil;
import com.abhibhut.Utils.AppForegroundService;
import com.abhibhut.Utils.BrowserUtils;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MethodChannel extends FlutterActivity{

    private static final String AppData_channel = "AppHandler/AppData";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        /*Channel for getting Installed Apps list */
        new io.flutter.plugin.common.MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), AppData_channel)
                .setMethodCallHandler(
                        (call, result) -> {
                            if(call.method.equals("AppList"))
                            {
                                List<Map<String, Object>> applist = AppData.InstalledAppList(getApplicationContext());
                                result.success(applist);
                            }
                            /*Check whether Foreground Service is running or not */
                            if(call.method.equals("check_foreground_service")) {
                                Boolean is_running = false;
                                ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
                                /*Iterate through all the services to check whether the foreground service is running or not*/
                                for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
                                    if (AppForegroundService.class.getName().equals(service.service.getClassName())) {
                                        is_running = true;
                                    }
                                }
                                if (!is_running) {
                                    Intent serviceIntent = new Intent(this, AppForegroundService.class);
                                    ContextCompat.startForegroundService(this, serviceIntent);
                                }
                            }
                            /*Check whether accessibility is enabled or not*/
                            if(call.method.equals("check_accessibility"))
                            {
                                Boolean access_bility_access = AccessibilityUtil.isAccessibilityServiceEnabled(getApplicationContext());
                                result.success(access_bility_access);
                            }
                            if(call.method.equals("grant_accessibility"))
                            {
                                //this method is a void method , however if you want to track
                                //whether the service got enabled or not , then you can return a bool value
                                AccessibilityUtil.grantAccessibilityPermission(getApplicationContext());
                            }
                            if(call.method.equals("enable_broswer_porn_lock"))
                            {
                                Context context = getApplicationContext();
                                /*Add broswer packages in Accessibility service config , once packages are included
                                * porn lock is handeled in onEvent Autimatically*/
                                List<String> all_browsers = BrowserUtils.getInstalledBrowsers(context);
                                BrowserUtils.getInstalledBrowsers(context);
                                AccessibilityUtil util = new AccessibilityUtil();
                                /*This will add package name in Accessibility config*/
                                util.addPackageNameDynamically(all_browsers.toArray(new String[0]));
                            }
                            if(call.method.equals("enable_app_lock"))
                            {
                                Context context = getApplicationContext();
                                /* Add App packages in Accessibility service config , once packages are included
                                 * porn lock is handeled in onEvent Autimatically*/
                                AccessibilityUtil util = new AccessibilityUtil();
                                List<String> block_packages = call.argument("PackageNames");
                                util.addPackageNameDynamically(block_packages.toArray(new String[0]));
                                // Update sql table
                            }
                            if(call.method.equals("disable_app_lock"))
                            {
                                List<String> unblock_packages = call.argument("PackageNames");
                                AccessibilityUtil util = new AccessibilityUtil();
                                util.removePackageNameDynamically(unblock_packages);
                            }
                            if(call.method.equals("get_icon"))
                            {
                                Context context = getApplicationContext();
                                PackageManager mgr = context.getPackageManager();
                                String pkg_nm = call.argument("package_nm");
                                byte[] icon = AppData.get_icon(mgr,pkg_nm);
                                result.success(icon);
                            }
                        });
    }
}

