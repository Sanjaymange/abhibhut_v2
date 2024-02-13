import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  late List<Map<Object?, Object?>> _appList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppList();
  }

  Future<void> _loadAppList() async {
    dynamic appdata =
        await MethodChannel('AppHandler/AppData').invokeMethod('AppList');
    //.then((value) => value?.cast<Map<String, Object>>());
    //List<Map<Object, Object>> appList = appdata as List<Map<Object, Object>>;
    List<Map<Object?, Object?>> appList =
        List<Map<Object?, Object?>>.from(appdata);
    setState(() {
      // ?? means if it is null then we will pass a default []
      _appList = appList;
      _isLoading = false;
    });
  }

  /* All map will not have same keys hence use this logic in your widget
  
  // Assume data is received from the native Android method
List<Map<String, dynamic>> receivedData = await platformMethodCall();

for (var map in receivedData) {
  // Handle common keys
  var commonValue = map['commonKey'];

  // Handle additional keys dynamically
  map.forEach((key, value) {
    if (!commonKeys.contains(key)) {
      // Handle additional key-value pairs as needed
    }
  });
}
  
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Installed Apps'),
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while loading data
          : ListView.builder(
              itemCount: _appList.length,
              itemBuilder: (BuildContext context, int index) {
                final app = _appList[index];
                return ListTile(
                  leading:
                      Image.memory(app['icon'] as Uint8List), // Show app icon
                  title: Text(app['app_name'] as String), // Show package name
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0), // Add padding between rows
                );
              },
            ),
    );
  }
}
