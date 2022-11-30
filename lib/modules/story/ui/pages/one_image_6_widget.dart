import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class OneImage6Widget extends StatelessWidget {
  static const String tag = "PN_";

  final ImageModel image;
  final double multiplier;

  const OneImage6Widget({
    required this.image,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12 * multiplier),
            margin: EdgeInsets.only(top: 20 * multiplier),
            decoration: BoxDecoration(
              color: Theme.of(context).noteCardColor,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(Theme.of(context).borderRadius * multiplier),
              ),
            ),
            child: Text(
              image.note ?? "",
              style: TextStyle(
                fontSize: 8 * multiplier,
                letterSpacing: 0.2,
                height: 1.2,
                color: Theme.of(context).onNoteCardColor,
              ),
            ),
          ),
        ),
        SizedBox(width: 10 * multiplier),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: image.height / image.width * 270 < 400
                ? BorderRadius.only(topLeft: Radius.circular(Theme.of(context).borderRadius * multiplier))
                : null,
          ),
          child: ImageWidget(image: image),
        ),
      ],
    );
  }
}
