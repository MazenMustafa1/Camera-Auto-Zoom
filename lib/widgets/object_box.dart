import 'package:flutter/material.dart';

class ObjectBox extends StatelessWidget {
  const ObjectBox(
      {super.key,
      required this.X,
      required this.Y,
      required this.W,
      required this.H,
      required this.label});

  final H, Y, X, W, label;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Y,
      left: X,
      child: Container(
        width: W,
        height: H,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow, width: 4.0),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(color: Colors.white, child: Text(label)),
          ],
        ),
      ),
    );
  }
}
