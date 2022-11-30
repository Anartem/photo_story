import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class TwoImages3Widget extends StatelessWidget {
  static const String tag = "LLTN_";

  final ImageModel image1;
  final ImageModel image2;
  final double multiplier;

  const TwoImages3Widget({
    required this.image1,
    required this.image2,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(Theme.of(context).borderRadius * multiplier),
                    ),
                  ),
                  child: ImageWidget(image: image1),
                ),
                SizedBox(height: 10 * multiplier),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(Theme.of(context).borderRadius * multiplier),
                    ),
                  ),
                  child: ImageWidget(image: image2),
                ),
              ],
            ),
          ),
          SizedBox(width: 10 * multiplier),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 40 * multiplier),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 2 * multiplier),
                  Text(
                    (image1.title?.isNotEmpty == true ? image1.title! : image2.title!).toUpperCase(),
                    style: TextStyle(
                      fontSize: 16 * multiplier,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      height: 1.0,
                      color: Theme.of(context).titleColor,
                    ),
                  ),
                  Text(
                    image1.note?.isNotEmpty == true ? image1.note! : image2.note!,
                    style: TextStyle(
                      fontSize: 8 * multiplier,
                      letterSpacing: 0.2,
                      height: 1.2,
                      color: Theme.of(context).noteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20 * multiplier),
        ],
      ),
    );
  }
}
