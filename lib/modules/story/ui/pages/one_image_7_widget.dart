import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class OneImage7Widget extends StatelessWidget {
  static const String tag = "LN_";

  final ImageModel image;
  final double multiplier;

  const OneImage7Widget({
    required this.image,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 320 * multiplier,
            padding: EdgeInsets.all(Theme.of(context).cardPadding * multiplier),
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
        SizedBox(height: 10 * multiplier),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              alignment: Alignment.bottomRight,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: constraints.maxHeight * image.width / image.height < constraints.maxWidth
                      ? const BorderRadius.only(topLeft: Radius.circular(8))
                      : null,
                ),
                child: ImageWidget(image: image),
              ),
            );
          },
        ),
      ],
    );
  }
}
