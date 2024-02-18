import 'package:abhibhut_v2/utils/Common_utils.dart';
import 'package:flutter/services.dart';

class AppBlockUtils {
/** Note that we need to pass package name and not label of that app in input params */

  static block_app(List<String> block_pkgs) async {
    MethodChannel channel = new MethodChannel('AppHandler/AppData_channel');
    await channel.invokeMethod('enable_app_lock', block_pkgs);
  }
}
