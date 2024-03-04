import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './display_picture.dart';
import '../widgets/camera.dart';
import '../controllers/scan_controller.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late ScanController globalController;

  capturePicture(BuildContext context) async {
    //Take a Picture when this button is pressed
    try {
      final image = await globalController.cameraController.takePicture();

      if (!context.mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureView(
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            globalController = controller;

            return controller.isCameraInitialized != false.obs
                ? Camera(controller: controller)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          capturePicture(context);
        },
        child: const Icon(
          Icons.camera_alt,
        ),
      ),
    );
  }
}
