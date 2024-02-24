import 'package:abhibhut_v2/Screens/AppList.dart';
import 'package:abhibhut_v2/Screens/NameInputPage.dart';
import 'package:abhibhut_v2/utils/Routes.dart';
import 'package:abhibhut_v2/utils/SqlHelper.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class FirstRun extends StatefulWidget {
  const FirstRun({super.key});

  @override
  State<FirstRun> createState() => _FirstRunState();
}

class _FirstRunState extends State<FirstRun>
    with SingleTickerProviderStateMixin {
  late AnimationController anm_controller;
  late Animation<double> _animation;
/*We are only loading package names of all apps in our first run */

  Future<void> _insert_installed_apps() async {
    print('inside _insert_installed_apps');
    DatabaseHelper db = DatabaseHelper();
    db.database.then((value) async {
      dynamic appdata =
          await MethodChannel('AppHandler/AppData').invokeMethod('AppList');
      for (var app in appdata) {
        await db.InsertData(
            "INSERT INTO APP_DATA (APP_LABEL,PACKAGE_NM,BLOCKED,START_TIME,END_TIME) VALUES (?,?,?,?,?)",
            [
              app['app_name'],
              app['package_name'],
              app['blocked_app'],
              app['start_time'],
              app['end_time']
            ]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _insert_installed_apps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated text appearing word by word
              AnimatedTextKit(
                pause: Duration(milliseconds: 1000),
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText('Hi,'),
                  TyperAnimatedText('My name is Abhibhut.',
                      speed: Duration(milliseconds: 150)),
                  TyperAnimatedText('I am here to help you.',
                      speed: Duration(milliseconds: 150)),
                  TyperAnimatedText(
                      'But first, let\'s get some Introduction....',
                      speed: Duration(milliseconds: 150)),
                ],
                onFinished: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => NameInputPage()),
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.cyan[50]);
  }
}
