import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abhibhut_v2/utils/Routes.dart';

class NameInputPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  void update_user_profile_shared_preference(String username) async {
    SharedPreferences pref = await getSharedPreference();
    await pref.setString('User_name', username);
    print('Username from shared preference: ${pref.getString('User_name')}');
  }

  Future<SharedPreferences> getSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "What's your good name ?",
                style: TextStyle(fontSize: 20, color: Colors.blue[200]),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Updating first run false should be moved at some other place if any
                  // new fields are added after Asking name
                  getSharedPreference()
                      .then((value) => value.setBool('isFirstRun', false));

                  String enteredName = _nameController.text;

                  if (enteredName.trim().isNotEmpty) {
                    update_user_profile_shared_preference(enteredName);
                    Navigator.pushNamed(context, App_Routes.HomeScreen);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter your name.'),
                    ));
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.cyan[50]);
  }
}
