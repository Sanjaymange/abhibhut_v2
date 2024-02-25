import 'package:flutter/services.dart';

class AppData {
  //This is made static so all the classes can use the List of AppData
  static List<AppData> all_apps = [];

  int? app_id;
  late String package_nm;
  late String app_label;
  late bool blocked;
  int? start_time;
  int? end_time;
  Future<Uint8List?> icon;

  AppData(
      {this.app_id,
      required this.package_nm,
      required this.app_label,
      required this.blocked,
      this.start_time,
      this.end_time,
      required this.icon});

  factory AppData.fromMap(Map<dynamic?, dynamic?> map, String Package_name) {
    return AppData(
        app_id: map["app_id"],
        package_nm: map["package_name"],
        app_label: map["app_name"],
        blocked: map["blocked_app"],
        start_time: map["start_time"],
        end_time: map["end_time"],
        icon: getIcon(Package_name));
  }

  static Future<Uint8List> getIcon(String pkg_nm) async {
    MethodChannel channel = MethodChannel('AppHandler/AppData');
    Uint8List icon =
        await channel.invokeMethod('get_icon', {'package_nm': pkg_nm});
    if (icon.isNotEmpty) {
      return icon;
    } else {
      // add a default image in your assets and pass it when icon is not found.
      return Uint8List(0); // replace defaultIcon with the actual default image
    }
  }

  static Future<void> load_all_AppList() async {
    dynamic appdata =
        await MethodChannel('AppHandler/AppData').invokeMethod('AppList');
    await appdata.forEach((app) {
      all_apps.add(AppData.fromMap(app, app['package_name']));
    });
  }
}
