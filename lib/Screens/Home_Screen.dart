import 'package:abhibhut_v2/DataObjects/AppData.dart';
import 'package:abhibhut_v2/DataObjects/AppUsage.dart';
import 'package:abhibhut_v2/Widgets/BargraphWidget.dart';
import 'package:abhibhut_v2/Widgets/EnablePremiumDialogue.dart';
import 'package:abhibhut_v2/utils/App_block_utils.dart';
import 'package:abhibhut_v2/utils/Common_utils.dart';
import 'package:abhibhut_v2/utils/Porn_block_utils.dart';
import 'package:abhibhut_v2/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:abhibhut_v2/utils/Permissions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* I have added weekly_usage stats and Monthly usage stats in Usage_stats class */

  /*This boolean is used to check if all the apps are loaded */
  bool all_apps_loaded = false;
  bool usageStatsloaded = false;
  List<AppData> appData = [];
  Map<String, AppUsage> appUsageStats = {};
  String tenure = '';
  final device_height = MediaQueryData().size.height;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() async {
    await load_app_data();
    await default_daily_stats_load(appData);
  }

  Future<void> default_daily_stats_load(List<AppData> user_apps) async {
    loadStats("daily", user_apps);
  }

  Future<void> load_app_data() async {
    appData = await AppData.load_all_AppList();
    setState(() {
      all_apps_loaded = true;
    });
  }

  /**Below function will be used to get daily usage stats based on user's input*/
  Future<void> loadStats(String tenure, List<AppData> user_apps) async {
    Map<String, AppUsage> usageStats = {};
    if (tenure == 'daily') {
      DateTime endDate = DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      List<EventUsageInfo> all_events =
          await UsageStats.queryEvents(startDate, endDate);
      List<EventUsageInfo> events =
          await AppUsage.filter_user_apps(all_events, appData);
      usageStats = await AppUsage.aggregateData(
          events, startDate.millisecondsSinceEpoch);
      /*   if (usageStats.containsKey('com.google.android.youtube')) {
        print(
            'package_name : ${usageStats['com.google.android.youtube']!.PackageName}');
        print(
            'duration : ${usageStats['com.google.android.youtube']!.duration}');
      }*/
      appUsageStats = usageStats;
      setState(() {
        usageStatsloaded = true;
      });
    } else if (tenure == 'weekly') {
      appUsageStats = usageStats;
      setState(() {
        usageStatsloaded = true;
      });
    }
    /**Final is yearly */
    else {
      appUsageStats = usageStats;
      setState(() {
        usageStatsloaded = true;
      });
    }
  }

  Future<List<AppUsage>> getTop5(Map<String, AppUsage> usageStats) async {
    List<AppUsage> sortedList = usageStats.values.toList();
    sortedList.sort((a, b) => b.duration!.compareTo(a.duration!));
    sortedList.removeRange(5, sortedList.length);
    /* if the duration is more than an hour for any app , then the graph will show data in hours , else in minutes */
    if (sortedList[0].duration! >= 3600000) {
      for (int i = 0; i <= 4; i++) {
        sortedList[i].app_icon =
            await AppData.getIcon(sortedList[i].PackageName!);
        sortedList[i].duration = (sortedList[i].duration! ~/ 1000) ~/ 3600;
      }
    } else {
      for (int i = 0; i <= 4; i++) {
        sortedList[i].app_icon =
            await AppData.getIcon(sortedList[i].PackageName!);
        sortedList[i].duration = (sortedList[i].duration! ~/ 1000) ~/ 60;
      }
    }
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Abhibhut"),
        ),
        body: Stack(children: [
          all_apps_loaded
              ? Center(
                  child: ListView(
                  children: [
                    SizedBox(
                        //height: device_height * 0.250,
                        height: 250,
                        child: usageStatsloaded
                            ? FutureBuilder<List<AppUsage>>(
                                future: getTop5(appUsageStats),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return BargraphWidget(
                                        tenure: tenure,
                                        BarGrpupList: snapshot.data!);
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })
                            : CircularProgressIndicator()),
                    Text("Daily usage stats size box"),
                    GestureDetector(
                      child: Text("Block_Porn"),
                      onTap: () async {
                        bool premiumuser = await CommonUtils.IsPremiumUser();
                        if (premiumuser) {
                          bool accessibility_enabled =
                              await CommonUtils.IsAccessibilityEnabled();
                          if (accessibility_enabled) {
                            //EnableAccessibilityDialogue();
                          } else {
                            Porn_block_utils.porn_block();
                          }
                        } else {
                          EnablePremiumDialogue();
                        }
                        /**Show timer or options of how long we want to keep it blocked */

                        /**Show timer or options of how long we want to keep it blocked */
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Text("Block App"),
                      /** check whether we can use async in ontap callback function */
                      onTap: () async {
                        bool premiumuser = await CommonUtils.IsPremiumUser();
                        if (premiumuser) {
                          bool accessibility_enabled =
                              await CommonUtils.IsAccessibilityEnabled();
                          if (accessibility_enabled!) {
                            //EnableAccessibilityDialogue();
                          } else {
                            AppBlockUtils().block_app(["com.android.youtube"]);
                          }
                        } else {
                          EnablePremiumDialogue();
                        }
                        /**Show timer or options of how long we want to keep it blocked */
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("All Blocked Apps"),
                    GestureDetector(
                      child: Text("See All Apps"),
                      /** check whether we can use async in ontap callback function */
                      onTap: () {
                        Navigator.pushNamed(context, App_Routes.AppList);
                      },
                    ),
                  ],
                ))
              : Center(child: Text('Hold on checking stats permission...'))
        ]));
  }
}
