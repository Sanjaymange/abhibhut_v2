import 'package:abhibhut_v2/utils/SqlHelper.dart';

class UsageStats {
  int? appId;
  //int? weekly_Usage;
  //int? monthly_Usage;
  int? Usage;
  //int? Weekly_saved_hours;
  //int? Monthly_saved_hours;
  int? saved_hours;
  //int? average_Usage_weekly;
  //int? average_Usage_monthly;
  int? average_Usage;
  //int? weekly_blocked_times;
  //int? monthly_blocked_times;
  int? blocked_times;

  String? tenure;

  DatabaseHelper db = DatabaseHelper();

  /*UsageStats({
    this.appId,
    this.weekly_Usage,
    this.monthly_Usage,
    this.Weekly_saved_hours,
    this.Monthly_saved_hours,
    this.average_Usage_weekly,
    this.average_Usage_monthly,
    this.weekly_blocked_times,
    this.monthly_blocked_times,
  });*/

  UsageStats(
      {this.appId,
      this.Usage,
      int? saved_hours,
      int? average_Usage,
      int? blocked_times,
      String? tenure});

  /*factory UsageStats.fromDB(Map<String, dynamic> json) {
    return UsageStats(
      appId: json["app_id"],
      weekly_Usage: json["weekly_usage"],
      monthly_Usage: json["monthly_usage"],
      Weekly_saved_hours: json["weekly_saved_hours"],
      Monthly_saved_hours: json["monthly_saved_hours"],
      average_Usage_weekly: json["average_usage_weekly"],
      average_Usage_monthly: json["average_usage_monthly"],
      weekly_blocked_times: json["weekly_blocked_times"],
      monthly_blocked_times: json["monthly_blocked_times"],
    );
  }*/

  factory UsageStats.fromDB(Map<String, dynamic> json, String tenure) {
    switch (tenure) {
      case 'weekly':
        return UsageStats(
          appId: json["app_id"],
          Usage: json["weekly_usage"],
          saved_hours: json["weekly_saved_hours"],
          average_Usage: json["average_usage_weekly"],
          blocked_times: json["weekly_blocked_times"],
        );
      case 'monthly':
        return UsageStats(
          appId: json["app_id"],
          Usage: json["monthly_usage"],
          saved_hours: json["monthly_saved_hours"],
          average_Usage: json["average_usage_monthly"],
          blocked_times: json["monthly_blocked_times"],
        );
      default:
        return UsageStats();
    }
    // Handle other cases if necessary
  }

  // Handle other tenures if needed

  /** We have different columns for Monthly , Weekly ; hence we are having all those attributes */
  Future<List<Map<String, dynamic>>> load_usage_stats(String? tenure) async {
    List<UsageStats> usageStatsList = [];
    List<Map<String, dynamic>> data = [];

    //Question - when we will update usage stats ?
    // Every time when the app is started , we will add (i.e sum) today's usage stats with existing using stats in the table
    // and display on scren the modified weekly stats.

    // At night 3 am there will be a back_up stats to update total counts in the table for today's usage stats
    // same for monthly usage stats
    /* One month Usage stats */
    if (tenure == 'monthly') {
      data = await db.queryData(
          '''SELECT TOP 5 AD.PACKAGE_NM , MONTHLY_USGAE , MONTHLY_SAVED_HOURS , AVERAGE_USAGE_MONTHLY  FROM USAGE_STATS UTS 
      INNER JOIN APP_DATA AD ON UTS.APP_ID = AD.APP_ID
      ORDER BY MONTHLY_USGAE DESC''');
    }
    /**We are only preserving monthly and weekly , so if the tenure is not 'monthly' then it is by default weekly */
    else {
      data = await db.queryData(
          '''SELECT TOP 5 AD.PACKAGE_NM , WEEKLY_USGAE , WEEKLY_SAVED_HOURS , AVERAGE_USAGE_WEEKLY  FROM USAGE_STATS UTS 
      INNER JOIN APP_DATA AD ON UTS.APP_ID = AD.APP_ID
      ORDER BY WEEKLY_USGAE DESC''');
    }
    return data;
  }
}
