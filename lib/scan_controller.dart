import 'dart:typed_data';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img ;
export 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:flutter_tts/flutter_tts.dart';


class ScanController extends GetxController {

  var recognitions ;
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  late CameraImage _cameraImage ;
  final FlutterTts flutterTts = FlutterTts();

  final RxList<Uint8List> _imageList = RxList([]);
  int _imageCount = 0 ;
  bool _captureFlag = false;

  final RxBool _isInitialized = RxBool(false );
  bool get isInitialized => _isInitialized.value ;
  CameraController get cameraController => _cameraController ;
  List<Uint8List> get imageList => _imageList ;
  get reco => recognitions ;

  @override
  void dispose(){
    _isInitialized.value = false ;
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> _initTFlite() async {

    await Tflite.loadModel(
        model: "assets/objects_mobilenet.tflite",
        labels: "assets/objects_mobilenet.txt",
        numThreads: 2, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );

  }


  Future<void> initCamera () async {

    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {

      _isInitialized.value = true ;

      _cameraController.startImageStream((image) {



        /*_imageCount ++ ;
        if(_imageCount == 300 ){
          _imageCount = 0 ;
          print ('errrrrror');
          objectRecoginition(image); // using tensorflow
        }
        */

        //print(DateTime.now().millisecondsSinceEpoch);

        _cameraImage = image ;
        if(_captureFlag){
          objectRecoginition(_cameraImage);
          _captureFlag = false ;
        }

      });


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
  void onInit() {
    initCamera();
    _initTFlite();
    super.onInit();
  }


  /*
  * object detection model using tensor flow

  * * need solve error
  * */
  Future<void> objectRecoginition (CameraImage cameraImage) async {

    recognitions = await Tflite.runModelOnFrame(
        bytesList: cameraImage.planes.map((plane) {return plane.bytes;}).toList(),// required
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,   // defaults to 127.5
        imageStd: 127.5,    // defaults to 127.5
        rotation: 90,       // defaults to 90, Android only
        numResults: 2,      // defaults to 5
        threshold: 0.1,     // defaults to 0.1
        asynch: true        // defaults to true
    );


    String myOutput ="Sorry I Can\'t Recognize this Object ";
    double acc = 0 ;
    for (int i = 0 ; i < recognitions.length ; i ++ ){
        if(recognitions[i]['confidence'] > acc && recognitions[i]['confidence'] > .50  ){
          myOutput = "my recognition is ${recognitions[0]['label']} ";
          acc = recognitions[i]['confidence'];
        }
    }
    _textToSpeech(myOutput);
    print(recognitions);
  }

  void capturre ()async {
    _captureFlag = true ;

    img.Image image = img.Image.fromBytes(
        _cameraImage.width,
        _cameraImage.height,
        _cameraImage.planes[0].bytes ,
        format: img.Format.bgra
    );

    Uint8List  jpeg  = Uint8List.fromList(img.encodeJpg(image));


    _imageList.add(jpeg);
    _imageList.refresh();
    print('added ${jpeg.length} and  ${_imageList.length}');

  }

  void _textToSpeech (String txt)async {

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(txt);

  }




}
