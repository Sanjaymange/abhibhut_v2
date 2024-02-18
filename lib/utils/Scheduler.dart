import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Scheduler2 {
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
  @pragma('vm:entry-point')
  static void printHello() {
    final DateTime now = DateTime.now();
    // final int isolateId = Isolate.current.hashCode;
//  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  }

/* We can still work with shared preference , create Blocked_apps class , create all attributes we have mentioned in the
shared preferencfe , create a static list of List<Blocked_apps> and initialise in the begning of app in init and use 
that list to block the apps */

  main() async {
    // Be sure to add this line if initialize() call happens before runApp()
    WidgetsFlutterBinding.ensureInitialized();

    await AndroidAlarmManager.initialize();
    // runApp(...);
    final int helloAlarmID = 0;
    await AndroidAlarmManager.periodic(
        const Duration(minutes: 1), helloAlarmID, printHello);
  }
}

class Scheduler {
  Future<bool> BeginBlocking() async {
    await AndroidAlarmManager.initialize();
    AndroidAlarmManager();
    return AndroidAlarmManager.oneShotAt(
        DateTime.now(), 0, () => print('this is the callback'),
        rescheduleOnReboot: true);
  }

  void UnSetBlocking(int AlarmID) async {
    MethodChannel channel = new MethodChannel('AppHandler/AppData_channel');

    await channel.invokeMethod('disable_app_lock');
  }
}
