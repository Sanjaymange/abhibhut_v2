import 'package:abhibhut_v2/utils/Common_utils.dart';
import 'package:flutter/services.dart';

class Porn_block_utils {
  static porn_block() async {
    MethodChannel channel = MethodChannel('AppHandler/AppData_channel');
    await channel.invokeMethod('enable_broswer_porn_lock');
  }
}
