import 'dart:typed_data';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart' ;
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img ;
import 'package:tflite_flutter/tflite_flutter.dart';
export 'package:google_mlkit_commons/google_mlkit_commons.dart';


class ScanController extends GetxController {

  var recognitions ;
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  late CameraImage _cameraImage ;

  final RxList<Uint8List> _imageList = RxList([]);
  int _imageCount = 0 ;


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
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/labels.txt",
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
        _imageCount ++ ;
        if(_imageCount == 20 ){
          _imageCount = 0 ;
          print ('errrrrror');
          objectRecoginition(image); // using tensorflow

        }
        //print(DateTime.now().millisecondsSinceEpoch);
        _cameraImage = image ;
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

    print(recognitions);
  }

  void capturre ()async {

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





}
