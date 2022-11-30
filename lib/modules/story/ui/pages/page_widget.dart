import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/models/page_model.dart';
import 'package:photo_story/modules/story/ui/pages/one_image_1_widget.dart';
import 'package:photo_story/modules/story/ui/pages/one_image_2_widget.dart';
import 'package:photo_story/modules/story/ui/pages/one_image_3_widget.dart';
import 'package:photo_story/modules/story/ui/pages/one_image_4_widget.dart';
import 'package:photo_story/modules/story/ui/pages/one_image_5_widget.dart';
import 'package:photo_story/modules/story/ui/pages/one_image_6_widget.dart';
import 'package:photo_story/modules/story/ui/pages/one_image_7_widget.dart';
import 'package:photo_story/modules/story/ui/pages/two_images_1_widget.dart';
import 'package:photo_story/modules/story/ui/pages/two_images_2_widget.dart';
import 'package:photo_story/modules/story/ui/pages/two_images_3_widget.dart';
import 'package:photo_story/modules/story/ui/pages/two_images_4_widget.dart';
import 'package:photo_story/modules/story/ui/pages/two_images_5_widget.dart';
import 'package:photo_story/modules/story/ui/pages/two_images_6_widget.dart';
import 'package:photo_story/modules/story/ui/pages/two_images_7_widget.dart';
import 'package:photo_story/modules/story/ui/theme_data_extension.dart';

abstract class PageWidget extends StatelessWidget {
  static const double divider = 400;

  static const List<String> supported = [
    OneImage1Widget.tag,
    OneImage2Widget.tag,
    OneImage3Widget.tag,
    OneImage4Widget.tag,
    OneImage5Widget.tag,
    OneImage6Widget.tag,
    OneImage7Widget.tag,
    TwoImages1Widget.tag,
    TwoImages2Widget.tag,
    TwoImages3Widget.tag,
    TwoImages4Widget.tag,
    TwoImages5Widget.tag,
    TwoImages6Widget.tag,
    TwoImages7Widget.tag,
  ];

  const PageWidget._({Key? key}) : super(key: key);

  factory PageWidget({required PageModel page, Key? key}) {
    String tag = PageWidget.supported.firstWhere((tag) => tag.contains(page.tag));

    if (page.images.length == 1) {
      return OneImageWidget(
        image: page.images[0],
        builder: (image, multiplier) {
          switch (tag) {
            case OneImage1Widget.tag:
              return OneImage1Widget(image: image);
            case OneImage2Widget.tag:
              return OneImage2Widget(image: image, multiplier: multiplier);
            case OneImage3Widget.tag:
              return OneImage3Widget(image: image, multiplier: multiplier);
            case OneImage4Widget.tag:
              return OneImage4Widget(image: image, multiplier: multiplier);
            case OneImage5Widget.tag:
              return OneImage5Widget(image: image, multiplier: multiplier);
            case OneImage6Widget.tag:
              return OneImage6Widget(image: image, multiplier: multiplier);
            case OneImage7Widget.tag:
              return OneImage7Widget(image: image, multiplier: multiplier);
            default:
              return Container();
          }
        },
      );
    }

    return TwoImagesWidget(
      image1: page.images[0],
      image2: page.images[1],
      builder: (image1, image2, multiplier) {
        switch (tag) {
          case TwoImages1Widget.tag:
            return TwoImages1Widget(image1: image1, image2: image2, multiplier: multiplier);
          case TwoImages2Widget.tag:
            return TwoImages2Widget(image1: image1, image2: image2, multiplier: multiplier);
          case TwoImages3Widget.tag:
            return TwoImages3Widget(image1: image1, image2: image2, multiplier: multiplier);
          case TwoImages4Widget.tag:
            return TwoImages4Widget(image1: image1, image2: image2, multiplier: multiplier);
          case TwoImages5Widget.tag:
            return TwoImages5Widget(image1: image1, image2: image2, multiplier: multiplier);
          case TwoImages6Widget.tag:
            return TwoImages6Widget(image1: image1, image2: image2, multiplier: multiplier);
          case TwoImages7Widget.tag:
            return TwoImages7Widget(image1: image1, image2: image2, multiplier: multiplier);
          default:
            return Container();
        }
      },
    );
  }
}

class OneImageWidget extends PageWidget {
  final ImageModel image;
  final Widget Function(ImageModel image, double multiplier) builder;

  const OneImageWidget({
    required this.image,
    required this.builder,
    Key? key,
  }) : super._(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: image.colors.first,
        ),
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double multiplier = constraints.maxWidth / PageWidget.divider;
              return Container(
                color: Theme.of(context).pageColor,
                alignment: Alignment.center,
                child: builder(image, multiplier),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TwoImagesWidget extends PageWidget {
  final ImageModel image1;
  final ImageModel image2;
  final Widget Function(ImageModel image1, ImageModel image2, double multiplier) builder;

  const TwoImagesWidget({
    required this.image1,
    required this.image2,
    required this.builder,
    Key? key,
  }) : super._(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.lerp(
            image1.colors.first,
            image2.colors.first,
            0.5,
          )!,
        ),
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double multiplier = constraints.maxWidth / PageWidget.divider;
              return Container(
                color: Theme.of(context).pageColor,
                alignment: Alignment.center,
                child: builder(image1, image2, multiplier),
              );
            },
          ),
        ),
      ),
    );
  }
}
