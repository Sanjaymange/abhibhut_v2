import 'package:abhibhut_v2/utils/user_profile_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abhibhut_v2/utils/Routes.dart';

class NameInputPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

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
                    /* Adding username in shared preference */
                    User_profile_utils.set_user_name(enteredName);
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
