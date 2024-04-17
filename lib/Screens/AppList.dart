import 'package:abhibhut_v2/DataObjects/AppData.dart';
import 'package:flutter/material.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Installed Apps'),
      ),
      body: ListView.builder(
        itemCount: AppData.all_apps.length,
        itemBuilder: (BuildContext context, int index) {
          final app = AppData.all_apps[index];
          return FutureBuilder<Uint8List?>(
            future: app.icon, // Use the iconFuture property
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the future is still loading, return a placeholder widget
                return CircularProgressIndicator(); // Or any other placeholder widget
              } else if (snapshot.hasError) {
                // If there was an error loading the future, display an error message
                return Text('Error: ${snapshot.error}');
              } else {
                // If the future has completed successfully, display the image
                return ListTile(
                  leading: Image.memory(snapshot.data!), // Use snapshot.data
                  title: app.blocked
                      ? Column(
                          children: [
                            Text(app.app_label),
                            Text("This app is Blocked"),
                          ],
                        )
                      : Text(app.app_label),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  trailing: Switch(
                    value: app.blocked,
                    onChanged: (value) {
                      // for testing purpose we are passing a widget as This app will be blocked
                      // later add an update method to update the database
                      setState(() {
                        app.blocked = value;
                      });
                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
