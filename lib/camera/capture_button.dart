import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../scan_controller.dart';

class CaptureButton extends GetView<ScanController> {
  const CaptureButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      child: FloatingActionButton(
        onPressed: ()=> controller.capturre(),
        child: Container(
          height: 80 ,
            width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          //child: Center(child: Icon(Icons.camera , size: 60,)),

        ),
      ),
    );
  }
}
