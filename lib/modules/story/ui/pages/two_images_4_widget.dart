import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

class TwoImages4Widget extends StatelessWidget {
  static const String tag = "PPTN_";

  final ImageModel image1;
  final ImageModel image2;
  final double multiplier;

  const TwoImages4Widget({
    required this.image1,
    required this.image2,
    required this.multiplier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 10 * multiplier),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 40 * multiplier),
              VerticalDivider(thickness: 2 * multiplier),
              Expanded(
                flex: 1,
                child: Text(
                  (image1.title?.isNotEmpty == true ? image1.title! : image2.title!).toUpperCase(),
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
                  image1.note?.isNotEmpty == true ? image1.note! : image2.note!,
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
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: image1.width * image2.height,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(Theme.of(context).borderRadius * multiplier),
                            topLeft: constraints.maxWidth / image1.width * image1.height > constraints.maxHeight
                                ? Radius.circular(Theme.of(context).borderRadius * multiplier)
                                : const Radius.circular(0.0),
                          ),
                        ),
                        child: ImageWidget(image: image1),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 10 * multiplier),
              Expanded(
                flex: image2.width * image1.height,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(Theme.of(context).borderRadius * multiplier),
                            topLeft: constraints.maxWidth / image2.width * image2.height > constraints.maxHeight
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
      ],
    );
  }
}
