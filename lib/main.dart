import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:objectreco2/scan_controller.dart';


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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScanController(),
      title: 'CameraApp',

    );
  }
}

