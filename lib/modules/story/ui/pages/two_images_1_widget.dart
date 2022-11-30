import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class TwoImages1Widget extends StatelessWidget {
  static const String tag = "LLN_";

  final ImageModel image1;
  final ImageModel image2;
  final double multiplier;

  const TwoImages1Widget({
    required this.image1,
    required this.image2,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(Theme.of(context).cardPadding * multiplier),
                margin: EdgeInsets.only(top: 20 * multiplier),
                decoration: BoxDecoration(
                  color: Theme.of(context).noteCardColor,
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(Theme.of(context).borderRadius * multiplier)),
                ),
                child: Text(
                  image1.note?.isNotEmpty == true ? image1.note! : image2.note!,
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
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Theme.of(context).borderRadius * multiplier),
                        bottomLeft: image2.width / image2.height * constraints.maxHeight > constraints.maxWidth
                            ? Radius.circular(Theme.of(context).borderRadius * multiplier)
                            : const Radius.circular(0.0),
                        bottomRight: image2.width / image2.height * constraints.maxHeight < constraints.maxWidth
                            ? Radius.circular(Theme.of(context).borderRadius * multiplier)
                            : const Radius.circular(0.0),
                      ),
                    ),
                    child: ImageWidget(image: image2),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10 * multiplier),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: image1.height / image1.width * 270 < 400
                ? BorderRadius.only(topLeft: Radius.circular(Theme.of(context).borderRadius))
                : null,
          ),
          child: ImageWidget(image: image1),
        ),
      ],
    );
  }
}
