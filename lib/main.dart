import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:objectreco2/scan_controller.dart';
import 'package:objectreco2/splash_screen.dart';


late List<CameraDescription>?cameras ;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CameraApp',
      initialRoute: "splash",
      routes: {
       "splash": (context)=>const SplashScreen(),
        "main_screen" :(context)=>const ScanController(),
      },

    );
  }
}

