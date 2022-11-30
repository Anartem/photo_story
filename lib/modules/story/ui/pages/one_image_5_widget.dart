import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';

class OneImage5Widget extends StatelessWidget {
  static const String tag = "PT_";

  final ImageModel image;
  final double multiplier;

  const OneImage5Widget({
    required this.image,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotatedBox(
          quarterTurns: -1,
          child: Text(
            image.title?.toUpperCase() ?? "",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 20 * multiplier,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              height: 1.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(width: 10 * multiplier),
        ImageWidget(image: image),
      ],
    );
  }
}
