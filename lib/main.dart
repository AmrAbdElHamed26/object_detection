import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'camera/camera_screen.dart';
import 'global_bindings.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: CameraScreen(),
      title: 'CameraApp',
      initialBinding: GlobalBindings(),

    );
  }
}

