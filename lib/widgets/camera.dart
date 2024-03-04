import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/scan_controller.dart';
import '../widgets/object_box.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.controller});

  final ScanController controller;
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  double? X, Y, W, H;
  double scale = 1.0;

  void initVariables(BuildContext context) {
    widget.controller.screenWidth = context.width;
    widget.controller.screenHeight = context.height;
    if (widget.controller.detectedFirstTime) {
      X = (widget.controller.x) * context.width;
      Y = (widget.controller.y) * context.height;
      W = widget.controller.w * context.width;
      H = widget.controller.h * context.height;
      // objectCenter = Alignment(X! + W! / 2, Y! + H / 2);
      // Alignment? objectCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    initVariables(context);

    return Stack(
      children: [
        Container(
            height: context.height,
            child: GestureDetector(
                onScaleUpdate: (ScaleUpdateDetails details) {
                  setState(() {
                    widget.controller.cameraController
                        .setZoomLevel(details.scale);
                  });
                },
                child: Transform.scale(
                  scale: scale,
                  child: CameraPreview(widget.controller.cameraController),
                ))),
        if (widget.controller.label != "")
          ObjectBox(X: X, Y: Y, W: W, H: H, label: widget.controller.label),
      ],
    );
  }
}
