import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Text("Daily usage stats"),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Text("Block_Porn"),
          onTap: () {
            // call function to block porn
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text("Block App"),
        SizedBox(
          height: 10,
        ),
        Text("All Blocked Apps")
      ],
    )));
  }
}
