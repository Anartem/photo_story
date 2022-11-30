import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class TwoImages7Widget extends StatelessWidget {
  static const String tag = "PP_";

  final ImageModel image1;
  final ImageModel image2;
  final double multiplier;

  const TwoImages7Widget({
    required this.image1,
    required this.image2,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: image1.width * image2.height,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(Theme.of(context).borderRadius * multiplier),
              ),
            ),
            child: ImageWidget(image: image1),
          ),
        ),
        SizedBox(
          width: 10 * multiplier,
        ),
        Expanded(
          flex: image2.width * image1.height,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(Theme.of(context).borderRadius * multiplier),
              ),
            ),
            child: ImageWidget(image: image2),
          ),
        ),
      ],
    );
  }
}
