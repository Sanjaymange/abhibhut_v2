import 'package:shared_preferences/shared_preferences.dart';

class User_profile_utils {
/* Check whether user is a premium user or not */
  static void enable_premium() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('EnablePremium', true);
  }

  static void disable_premium() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('EnablePremium', false);
  }

  static void set_user_name(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('UserName', name);
  }

  static Future<String> get_user_name() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString('UserName') ?? "";
  }
}
