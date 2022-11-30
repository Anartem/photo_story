import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';

class OneImage2Widget extends StatelessWidget {
  static const String tag = "PTN_STN_";

  final ImageModel image;
  final double multiplier;

  const OneImage2Widget({
    required this.image,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              clipBehavior: Clip.antiAlias,
              constraints: BoxConstraints(maxWidth: 280 * multiplier),
              decoration: BoxDecoration(
                borderRadius: image.width / image.height * 400 > 280
                    ? const BorderRadius.horizontal(right: Radius.circular(8.0))
                    : null,
              ),
              child: ImageWidget(image: image),
            ),
          ),
          SizedBox(width: 10 * multiplier),
          Container(
            padding: EdgeInsets.only(top: 40 * multiplier),
            width: 120 * multiplier,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 2 * multiplier),
                Text(
                  image.title?.toUpperCase() ?? "",
                  style: TextStyle(
                    fontSize: 16 * multiplier,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    height: 1.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  image.note ?? "",
                  style: TextStyle(
                    fontSize: 8 * multiplier,
                    letterSpacing: 0.2,
                    height: 1.2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20 * multiplier),
        ],
      ),
    );
  }
}
