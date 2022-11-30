import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class OneImage3Widget extends StatelessWidget {
  static const String tag = "LTN_STN_";

  final ImageModel image;
  final double multiplier;

  const OneImage3Widget({
    required this.image,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 40 * multiplier),
                VerticalDivider(thickness: 2 * multiplier),
                Expanded(
                  flex: 1,
                  child: Text(
                    image.title?.toUpperCase() ?? "",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16 * multiplier,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      height: 1.0,
                      color: Theme.of(context).titleColor,
                    ),
                  ),
                ),
                SizedBox(width: 10 * multiplier),
                Expanded(
                  flex: 2,
                  child: Text(
                    image.note ?? "",
                    style: TextStyle(
                      fontSize: 8 * multiplier,
                      letterSpacing: 0.2,
                      height: 1.2,
                      color: Theme.of(context).noteColor,
                    ),
                  ),
                ),
                SizedBox(width: 20 * multiplier),
              ],
            ),
          ),
          SizedBox(height: 10 * multiplier),
          ImageWidget(image: image),
        ],
      ),
    );
  }
}
