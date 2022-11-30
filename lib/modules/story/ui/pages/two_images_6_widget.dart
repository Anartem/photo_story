import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class TwoImages6Widget extends StatelessWidget {
  static const String tag = "LLN_LSN_";

  final ImageModel image1;
  final ImageModel image2;
  final double multiplier;

  const TwoImages6Widget({
    required this.image1,
    required this.image2,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(Theme.of(context).cardPadding * multiplier),
                  margin: EdgeInsets.only(top: 20 * multiplier),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(Theme.of(context).borderRadius * multiplier),
                    ),
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
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(Theme.of(context).borderRadius * multiplier),
                            topLeft: image2.width / image2.height * constraints.maxHeight > constraints.maxWidth
                                ? Radius.circular(Theme.of(context).borderRadius * multiplier)
                                : const Radius.circular(0.0),
                          ),
                        ),
                        child: ImageWidget(image: image2),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10 * multiplier),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints(maxWidth: 400 * multiplier, maxHeight: 270 * multiplier),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: image1.width / image1.height * 270 < 400
                  ? BorderRadius.only(topLeft: Radius.circular(Theme.of(context).borderRadius * multiplier))
                  : null,
            ),
            child: ImageWidget(image: image1),
          ),
        ),
      ],
    );
  }
}
