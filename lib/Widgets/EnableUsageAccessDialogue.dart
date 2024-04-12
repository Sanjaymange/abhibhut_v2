import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnableUsageAccessDialogue extends StatelessWidget {
  MethodChannel channel = MethodChannel('AppHandler/AppData');

  EnableUsageAccessDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Permission required"),
      content: Text(
          "To access usage statistics, please grant the usage permission to Abhibhut."),
      actions: <Widget>[
        TextButton(
          child: Text('Grant Permission'),
          onPressed: () async {
            await channel.invokeMethod('usage_stats_permission');
          },
        ),
      ],
    );
  }
}
