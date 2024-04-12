import 'package:abhibhut_v2/DataObjects/AppData.dart';
import 'package:abhibhut_v2/Widgets/EnablePremiumDialogue.dart';
import 'package:abhibhut_v2/utils/App_block_utils.dart';
import 'package:abhibhut_v2/utils/Common_utils.dart';
import 'package:abhibhut_v2/utils/Porn_block_utils.dart';
import 'package:abhibhut_v2/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* I have added weekly_usage stats and Monthly usage stats in Usage_stats class */

  bool all_apps_loaded = false;

  @override
  void initState() {
    super.initState();
    AppData.load_all_AppList().then((value) => setState(() {
          all_apps_loaded = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: all_apps_loaded
            ? Center(
                child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text("Daily usage stats"),
                  SizedBox(
                    height: 10,
                  ),
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
                        if (accessibility_enabled) {
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
            : Center(child: Text('Hold on checking stats permission...')));
  }
}
