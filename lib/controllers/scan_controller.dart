import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late double screenWidth;
  late double screenHeight;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var x, y, w, h = 0.0;

  String label = "";
  bool detectedFirstTime = false;

  @override
  void onInit() {
    initCamera();
    initTFLite();
    super.onInit();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController =
          await CameraController(cameras.first, ResolutionPreset.max);
      await cameraController.initialize().then((value) {});
      startStream();
      isCameraInitialized(true);
      update();
    } else {
      print("Permission Denied");
    }
  }

  void startStream() {
    cameraController.startImageStream((image) {
      cameraCount++;
      if (cameraCount % 10 == 0 && !detectedFirstTime) objectDetector(image);

      if (cameraCount % 60 == 0) {
        cameraCount = 0;
        objectDetector(image);
      }
      update();
    });
  }

  objectDetector(CameraImage image) async {
    List<dynamic>? detector = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    print("THE DETECTOR DETECTED THIS THING ->  $detector");
    if (detector != null && detector.isNotEmpty) {
      if (detector.first['confidenceInClass'] * 100 > 45) {
        label = detector.first['detectedClass'].toString();
        h = detector.first['rect']['h'];
        w = detector.first['rect']['w'];
        x = detector.first['rect']['x'];
        y = detector.first['rect']['y'];
        detectedFirstTime = true;
      }
      autoZoom();
      update();
    }
  }

  void autoZoom() {
    double screenArea = screenWidth * 2 + screenHeight * 2;
    double imageArea = (w * screenWidth) * 2 + (h * screenHeight) * 2;
    double zoomLevel = screenArea / imageArea;

    print('zoom level is $zoomLevel');

    cameraController.setZoomLevel(zoomLevel % 4);
  }

  initTFLite() async {
    try {
      String? result = await Tflite.loadModel(
          model: 'assets/ssd_mobilenet.tflite',
          labels: 'assets/ssd_mobilenet.txt',
          isAsset: true,
          numThreads: 1,
          useGpuDelegate: false);

      print('result is $result');
      print("Loaded");
    } catch (e) {
      print("Error in loading model $e");
    }
  }
}
