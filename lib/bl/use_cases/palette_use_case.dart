import 'dart:ui';

import 'package:image/image.dart' hide Color;
import 'package:palette_generator/palette_generator.dart';

class PaletteUseCase {
  Future<List<Color>> getPalette(Image image, [Rect? region, int count = 8]) {
    return _getPalette(image, region, count);
  }

  Future<List<Color>> _getPalette(Image image, [Rect? region, int count = 8]) {
    final EncodedImage encoded = EncodedImage(
      image.getBytes().buffer.asByteData(),
      width: image.width,
      height: image.height,
    );

    return PaletteGenerator
        .fromByteData(encoded, maximumColorCount: count, region: region)
        .then((generator) => generator.colors.toList());
  }
}
