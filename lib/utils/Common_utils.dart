import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils {
  /*Check whether the user is a premium user or not */
  static Future<bool> IsPremiumUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? premium = prefs.getBool('EnablePremium');
    if (premium == null || premium == false) {
      return false;
    } else
      return true;
  }

  /* Check if Accessibility is enabled or not */
  static Future<bool> IsAccessibilityEnabled() async {
    MethodChannel channel = MethodChannel('AppHandler/AppData_channel');
    bool accessibility = await channel.invokeMethod('check_accessibility');
    /* Call method channel to open settings to enable accessibility */
    return accessibility;
  }

  static void OpenAccessibilitySetting() async {
    MethodChannel channel = MethodChannel('AppHandler/AppData_channel');
    await channel.invokeMethod('open_accessibility_settings');
  }
}
