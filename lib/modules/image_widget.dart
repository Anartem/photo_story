import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_story/models/image_model.dart';

class ImageWidget extends StatelessWidget {
  final ImageModel image;
  final BoxFit fit;

  const ImageWidget({required this.image, this.fit = BoxFit.contain, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(image.path),
      fit: fit,
      frameBuilder: (context, child, frame, wasLoaded) {
        return wasLoaded || frame != null
            ? child
            : fit == BoxFit.cover
                ? Container(color: Theme.of(context).colorScheme.surfaceVariant)
                : AspectRatio(
                    aspectRatio: image.width / image.height,
                    child: Container(color: Theme.of(context).colorScheme.surfaceVariant),
                  );
      },
      gaplessPlayback: true,
    );
  }
}
