import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:objectreco2/camera/top_image_viewer.dart';


import 'camera_viewer.dart';
import 'capture_button.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
        alignment: Alignment.center,
        children: [
          CameraViewer(),
          CaptureButton(),

        ],
      ),
    );
  }
}
