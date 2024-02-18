package com.domain_name.abhibhut;
import android.content.Context;

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
                                AppData.update_master_shared_preference(context,AppData.read_pref(context));
                                /*This will update json in master shared preference , this is required because we take all
                                 * blocked apps named from shared preference , to show user blocked apps in AppLIST*/
                                AppData.update_master_shared_preference(context,AppData.read_pref(context));
                                /*Insert what type of Intent it wants during blocking an app , additional metadata like
                                * block interval and media url*/
                                /*This method is not tested yet , hence all the fields are inserted as null*/
                                AppData.update_app_shared_preference(null,null,0,0,null);
                            }
                            if(call.method.equals("disable_app_lock"))
                            {
                                List<String> unblock_packages = call.argument("PackageNames");
                                AccessibilityUtil util = new AccessibilityUtil();
                                util.removePackageNameDynamically(unblock_packages);
                            }
                        });
    }
}

