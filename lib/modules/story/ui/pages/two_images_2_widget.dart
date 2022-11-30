import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';

class TwoImages2Widget extends StatelessWidget {
  static const String tag = "LL_";

  final ImageModel image1;
  final ImageModel image2;
  final double multiplier;

  const TwoImages2Widget({
    required this.image1,
    required this.image2,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: image2.width * image1.height,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
            ),
            child: ImageWidget(image: image1),
          ),
        ),
        SizedBox(
          height: 10 * multiplier,
        ),
        Expanded(
          flex: image1.width * image2.height,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            ),
            child: ImageWidget(image: image2),
          ),
        ),
      ],
    );
  }
}
