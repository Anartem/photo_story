import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';

class OneImage4Widget extends StatelessWidget {
  static const String tag = "LT_";

  final ImageModel image;
  final double multiplier;

  const OneImage4Widget({
    required this.image,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ImageWidget(image: image),
        SizedBox(height: 10 * multiplier),
        Text(
          image.title?.toUpperCase() ?? "",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 26 * multiplier,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
            height: 1.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
