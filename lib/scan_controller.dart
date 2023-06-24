import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:tflite/tflite.dart';
import '../../../main.dart';

class ScanController extends StatefulWidget {
  const ScanController({Key? key}) : super(key: key);

  @override
  State<ScanController> createState() => _ScanControllerState();
}

class _ScanControllerState extends State<ScanController> {
  CameraImage? imgCamera;
  late CameraController controller;
  final FlutterTts flutterTts = FlutterTts();


  Future<dynamic> loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/objects_mobilenet.tflite",
        labels: "assets/objects_mobilenet.txt",
        numThreads: 2, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
        );
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    controller = CameraController(cameras![0], ResolutionPreset.max );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      controller.startImageStream((image) {
        imgCamera = image;

      });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 5,
        threshold: 0.1,
        asynch: true,
      );
      
      List<String> allLabels = [];
      for (int i = 0 ; i < recognitions!.length ; i ++ ){
        print(recognitions[i]['label']);
        allLabels.add(recognitions[i]['label']);
      }

      String result ="";
      for (int i = 0 ; i < allLabels!.length - 2  ; i ++ ){
        result += allLabels[i];
        result+= " , " ;
      }
      result = result + allLabels[allLabels!.length-2] + " and " + allLabels[allLabels!.length-1];

      result = "This image containes " + result ;
      _textToSpeech(result) ;
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Object Detection App"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CameraPreview(controller),
      ),
      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.indigo,
        onPressed: runModelOnStreamFrames,
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  void _textToSpeech (String txt)async {

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(txt);

  }

}

