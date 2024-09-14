import 'package:abhibhut_v2/utils/Permissions.dart';
import 'package:flutter/material.dart';

class PermissionsUI extends StatefulWidget {
  Map<String, bool> permissions = {};

  PermissionsUI({super.key, required this.permissions});

  @override
  State<PermissionsUI> createState() => _PermissionsUIState();
}

class _PermissionsUIState extends State<PermissionsUI> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            // Image section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                  'assets/Images/usage_diagram.png'), // Replace with your image URL or asset path
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Usage Stats Permission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Required for showing your phone usage statistics',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Steps Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Step 1
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          'Find Stay Focused on next screen',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // App Icon with Text
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          'assets/Images/trial_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stay Focused',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('Off',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Step 2
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2. ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          'Click it and turn on the switch like below',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Permission Toggle Example
                  Card(
                    margin: EdgeInsets.all(8),
                    elevation: 2,
                    child: ListTile(
                      title: Text('Permit usage access'),
                      trailing: Switch(
                        value: true,
                        onChanged: (bool value) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button color
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Permissions.grant_usage_permission();
                },
                child: Center(
                  child: Text(
                    'CLICK TO GRANT',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
