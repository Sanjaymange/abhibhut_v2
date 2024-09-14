import 'package:abhibhut_v2/Screens/AppList.dart';
import 'package:abhibhut_v2/Screens/First_run.dart';
import 'package:abhibhut_v2/Screens/Home_Screen.dart';
import 'package:abhibhut_v2/Screens/PermissionsUI.dart';
import 'package:abhibhut_v2/Widgets/EnableUsageAccessDialogue.dart';
import 'package:abhibhut_v2/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  Future<Map<String, bool>> check_all_permissions() async {
    Map<String, bool> permissions = {};
    permissions['usage'] = await Permissions.check_usage_permission();
    permissions['accessibility'] =
        await Permissions.check_accessibility_permission();
    return permissions;
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
              return FirstRun(); // Your widget for the first run
            } else {
              return FutureBuilder<Map<String, bool>>(
                future: check_all_permissions(),
                builder: (context, usagePermissionSnapshot) {
                  if (usagePermissionSnapshot.connectionState ==
                      ConnectionState.done) {
                    final permissions = usagePermissionSnapshot.data;
                    if (permissions!.containsValue(false)) {
                      // Show dialog for missing permissions
                      return PermissionsUI(
                          permissions:
                              permissions); // Your custom dialog or screen
                    } else {
                      return HomeScreen(); // If all permissions are granted
                    }
                  } else {
                    // While waiting for the permissions to be checked
                    return Image.asset('assets/Images/trial_image.jpg');
                  }
                },
              );
            }
          } else {
            // While waiting for the first run check to complete
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      routes: {
        App_Routes.AppList: (context) => AppList(),
        App_Routes.HomeScreen: (context) => HomeScreen()
      },
    );
  }
}
