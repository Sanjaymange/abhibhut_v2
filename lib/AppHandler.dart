import 'package:abhibhut_v2/Screens/AppList.dart';
import 'package:abhibhut_v2/Screens/First_run.dart';
import 'package:abhibhut_v2/Screens/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'utils/Routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: checkFirstRun(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking the first run status, display a loading indicator
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // If the app is running for the first time, navigate to the FirstRunPage
            // Otherwise, navigate to the HomePage
            if (snapshot.data == true) {
              return FirstRun();
            } else {
              return HomeScreen();
            }
          }
        },
      ),
      routes: {
        App_Routes.FirstRun: (context) => FirstRun(),
        App_Routes.AppList: (context) => AppList(),
        App_Routes.HomeScreen: (context) => HomeScreen()
      },
    );
  }
}
