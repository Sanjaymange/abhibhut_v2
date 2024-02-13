import 'package:abhibhut_v2/Screens/AppList.dart';
import 'package:abhibhut_v2/Screens/NameInputPage.dart';
import 'package:abhibhut_v2/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstRun extends StatefulWidget {
  const FirstRun({super.key});

  @override
  State<FirstRun> createState() => _FirstRunState();
}

class _FirstRunState extends State<FirstRun>
    with SingleTickerProviderStateMixin {
  late AnimationController anm_controller;
  late Animation<double> _animation;
/*We are only loading package names of all apps in our first run */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated text appearing word by word
              AnimatedTextKit(
                pause: Duration(milliseconds: 1000),
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText('Hi,'),
                  TyperAnimatedText('My name is Abhibhut.',
                      speed: Duration(milliseconds: 150)),
                  TyperAnimatedText('I am here to help you.',
                      speed: Duration(milliseconds: 150)),
                  TyperAnimatedText(
                      'But first, let\'s get some Introduction....',
                      speed: Duration(milliseconds: 150)),
                ],
                onFinished: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => NameInputPage()),
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.cyan[50]);
  }
}
