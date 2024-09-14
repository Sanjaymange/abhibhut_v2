import 'dart:ffi';
import 'dart:typed_data';

import 'package:abhibhut_v2/DataObjects/AppData.dart';
import 'package:usage_stats/usage_stats.dart';

class AppUsage {
  String? PackageName;
  int? timestamp;
  int? activityType;
  int? duration;
  int? start_time;
  int? end_time;
  Uint8List? app_icon;

  AppUsage(String PackageName, int timestamp, int activityType, int duration) {
    this.PackageName = PackageName;
    this.timestamp = timestamp;
    this.activityType = activityType;
    this.duration = duration;
  }

  /*
    1: "ACTIVITY_RESUMED"
    2: "ACTIVITY_PAUSED"
    19:"FOREGROUND_SERVICE_START"
    20:"FOREGROUND_SERVICE_STOP"
    23:"ACTIVITY_STOPPED"
  */

/**Merge package name with App name , to avoid inclusion of system events*/

  static Future<Map<String, AppUsage>> aggregateData(
      List<EventUsageInfo> events, int startDate) async {
    List<int> approved_ids = [1, 2, 19, 20, 23];
/*    ----------------------------------------------------------- */
    events.sort((a, b) => a.timeStamp!.compareTo(b.timeStamp!));
    print(
        'start_time = ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[0].timeStamp!))}');
    print(
        'end_time = ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[events.length - 1].timeStamp!))}');
    Map<String, AppUsage> aggregated_data = {};
    for (int i = 0; i <= events.length - 2; i++) {
      AppUsage appUsage = new AppUsage(events[i].packageName!,
          int.parse(events[i].timeStamp!), int.parse(events[i].eventType!), 0);

      /**Adding only required activities only*/
      if (approved_ids.contains(int.parse(events[i]
          .eventType!))) /*&&
          events[i].packageName == 'com.google.android.youtube')*/
      {
        /**Adding new packages */
        if (!aggregated_data.containsKey(events[i].packageName)) {
          aggregated_data[events[i].packageName!] = appUsage;
        }

        aggregated_data[events[i].packageName!]!.duration =
            aggregated_data[events[i].packageName!]!.duration! +
                (int.parse(events[i + 1].timeStamp!) -
                    int.parse(events[i].timeStamp!));

        print('packageName : ${events[i].packageName}');
        print('eventType : ${events[i].eventType}');
        print(
            'timeStamp : ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[i].timeStamp!))}');
        print(
            'timeStamp of next event : ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[i + 1].timeStamp!))}');
        print(
            'duration : ${aggregated_data[events[i].packageName!]!.duration}');
        //  }*/
      }
    }
    return aggregated_data;
  }

  static Future<List<EventUsageInfo>> filter_user_apps(
      List<EventUsageInfo> all_events, List<AppData> user_apps) async {
    all_events.removeWhere((element) =>
        !user_apps.any((app) => app.package_nm == element.packageName));
    return all_events;
  }
}
