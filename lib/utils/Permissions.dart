import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter/services.dart';

class Permissions {
  static Future<bool> check_usage_permission() async {
    bool value = await UsageStats.checkUsagePermission() ?? false;
    return value;
  }

  static void grant_usage_permission() async {
    UsageStats.grantUsagePermission();
  }

  static Future<bool> check_accessibility_permission() async {
    MethodChannel foreground_check_channel =
        MethodChannel('AppHandler/AppData');
    bool accessibility =
        await foreground_check_channel.invokeMethod('check_accessibility');
    return accessibility;
  }

  static void grant_accessibility_permission() async {
    MethodChannel foreground_check_channel =
        MethodChannel('AppHandler/AppData');
    foreground_check_channel.invokeMethod('grant_accessibility');
  }

/** There is no need to make this function as boolean , but as we cannot call void function directly in flutter,
 * we are keeping it as Future<bool>
 */
  static Future<bool> check_foreground_permission() async {
    MethodChannel foreground_check_channel =
        MethodChannel('AppHandler/AppData');
    foreground_check_channel.invokeMethod('check_foreground_service');
    return true;
  }
}
