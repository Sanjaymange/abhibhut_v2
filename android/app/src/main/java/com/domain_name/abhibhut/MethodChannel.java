package com.domain_name.abhibhut;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;

import com.abhibhut.Utils.AccessibilityUtil;
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
                            /*Check whether accessibility is enabled or not*/
                            if(call.method.equals("check_accessibility"))
                            {
                                boolean allowed = AccessibilityUtil.isAccessibilityServiceEnabled(getApplicationContext(),AccessibilityUtil.class);
                                result.success(allowed);
                            }
                            if(call.method.equals("open_accessibility_settings"))
                            {
                                AccessibilityUtil.openAccessibilitySettings(getApplicationContext());
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
                            if(call.method.equals("usage_stats_permission"))
                            {
                                Intent intent = new Intent(this, usage_access.class);
                                try {
                                    startActivity(intent);
                                } catch (Exception e) {
                                    // Handle the case where the activity couldn't be found
                                    System.out.println(e.getMessage());
                                    // Show a message to the user or provide an alternative option
                                }
                            }
                        });
    }
}

