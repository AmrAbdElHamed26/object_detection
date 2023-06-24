import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';
import '../../../main.dart';
import 'package:lottie/lottie.dart';

class ScanController extends StatefulWidget {
  const ScanController({Key? key}) : super(key: key);

  @override
  State<ScanController> createState() => _ScanControllerState();
}

class _ScanControllerState extends State<ScanController> {
  CameraImage? imgCamera;
  late CameraController controller;
  final FlutterTts flutterTts = FlutterTts();
  String _showedText = "";
  int _counter = 0;

  Future<dynamic> loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/objects_mobilenet.tflite",
      labels: "assets/objects_mobilenet.txt",
      numThreads: 2,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      controller.startImageStream((image) async {
        imgCamera = image;

        if (_counter == 100) {
          _showedText = await runModel(1);
          _counter = 0;
          setState(() {});
        }
        _counter++;
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

  Future<String> runModel(int c) async {
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

    if (c == 2) {
      List<String> allLabels = [];
      for (int i = 0; i < recognitions!.length; i++) {
        print(recognitions[i]['label']);
        allLabels.add(recognitions[i]['label']);
      }

      String result = "";
      for (int i = 0; i < allLabels!.length - 2; i++) {
        result += allLabels[i];
        result += " , ";
      }
      result =
          result + allLabels[allLabels.length - 2] + " and " + allLabels[allLabels.length - 1];

      result = "This image contains " + result;
      _textToSpeech(result);
      print(result);
    }
    print(recognitions);
    return recognitions![0]["label"];
  }

  @override
  Widget build(BuildContext context) {
    if (_counter == 0) setState(() {});

    if (!controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Object Detection"),
        leading: Lottie.asset('assets/96262-detective-search.json'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            CameraPreview(controller),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  _showedText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () async {
          String out = await runModel(2);
        },
        child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _textToSpeech(String txt) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(txt);
  }
}
