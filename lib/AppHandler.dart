import 'package:abhibhut_v2/Screens/AppList.dart';
import 'package:abhibhut_v2/Screens/First_run.dart';
import 'package:abhibhut_v2/Screens/Home_Screen.dart';
import 'package:abhibhut_v2/Widgets/EnableUsageAccessDialogue.dart';
import 'package:flutter/material.dart';
import 'utils/Routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';

class AppHandler extends StatefulWidget {
  const AppHandler({super.key});

  @override
  State<AppHandler> createState() => _AppHandlerState();
}

class _AppHandlerState extends State<AppHandler> {
  Future<bool> checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRun = prefs.getBool('isFirstRun');
    if (isFirstRun == null || isFirstRun == true) {
      // If isFirstRun is null or true, set it to false and return true
      // Alter isFirstRun to false at the end of first run
      // await prefs.setBool('isFirstRun', false);
      return true;
    } else {
      // If isFirstRun is false, return false
      return false;
    }
  }

  Future<bool?> check_usage_permission(BuildContext context) async {
    bool? usage_accessible = await UsageStats.checkUsagePermission();
    print(usage_accessible);
    return usage_accessible;
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
          future: checkFirstRun(),
          builder: (context, firstRunSnapshot) {
            if (firstRunSnapshot.connectionState == ConnectionState.done) {
              final isFirstRun = firstRunSnapshot.data;
              if (isFirstRun == true) {
                return FirstRun();
              } else {
                return HomeScreen(); /*FutureBuilder<bool?>(
                    future: check_usage_permission(context),
                    builder: (context, usagePermissionSnapshot) {
                      if (usagePermissionSnapshot.connectionState ==
                          ConnectionState.done) {
                        final usageAccessible = usagePermissionSnapshot.data;
                        if (usageAccessible == false) {
                          return EnableUsageAccessDialogue();
                        } else {
                          return HomeScreen();
                        }
                      } else {
                        // Second future still executing, return a placeholder or empty container
                        return SizedBox();
                      }
                    });
                //return HomeScreen();
              }
            } else {
              // this is like a temp placeholder , as
              return SizedBox();
            }
          */
              }
            } else {
              // this is like a temp placeholder , as
              return Text('loading app.....');
            }
          }),
      routes: {
        App_Routes.AppList: (context) => AppList(),
        App_Routes.HomeScreen: (context) => HomeScreen(),
        App_Routes.EnableUsageAccessDialogue: (context) =>
            EnableUsageAccessDialogue(),
      },
    );
  }
}
