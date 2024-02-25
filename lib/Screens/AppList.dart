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
          return ListTile(
            leading: Image.memory(app.icon), // Show app icon
            title: Text(app.app_label), // Show package name
            contentPadding: EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0), // Add padding between rows
          );
        },
      ),
    );
  }
}
