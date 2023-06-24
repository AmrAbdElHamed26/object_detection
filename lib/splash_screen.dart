import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization tasks here if needed
    // For example, you can load data or perform any setup tasks
    // before navigating to the main screen.

    // Simulate a delay before navigating to the main screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, 'main_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        child: Stack(
          children: [

            Lottie.asset(
              'assets/96262-detective-search.json',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),

          ]
        ),
      ),
    );
  }
}
