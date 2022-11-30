import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';

class OneImage1Widget extends StatelessWidget {
  static const String tag = "P_L_S_";

  final ImageModel image;

  const OneImage1Widget({required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageWidget(image: image);
  }
}
