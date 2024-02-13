package com.domain_name.abhibhut;
import androidx.annotation.NonNull;

import com.abhibhut.Utils.AccessibilityUtil;

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
                            if(call.method.equals(""))
                            {
                                boolean allowed = AccessibilityUtil.isAccessibilityServiceEnabled(getApplicationContext(),AccessibilityUtil.class);
                                result.success(allowed);
                            }
                        });
    }
}

