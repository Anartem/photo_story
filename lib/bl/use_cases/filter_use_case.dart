import 'dart:math';
import 'dart:ui';

import 'package:image/image.dart' hide Color;
import 'package:photo_story/bl/utils.dart';

class FilterUseCase {
  static const List<int> _sharpen = [-1, -1, -1, -1, 9, -1, -1, -1, -1];
  static const List<int> _gaussianBlur = [1, 2, 1, 2, 4, 2, 1, 2, 1];
  static const List<double> _highPass = [0, -0.25, 0, -0.25, 2, -0.25, 0, -0.25, 0];

  static const _brightness = 80;

  Future<Image> applyGrayScale({required Image image, bool monochromeOnly = true}) async {
    if (isMonochrome(image: image)) {}
    return image;
  }

  Future<Image> applySkinFilter(Image image, Rect rect, Color color) async {
    return Utils.isolate(() => _applySkinFilter(image, rect, color));
  }

  Future<Image> applyPortraitFilter(Image image) async {
    image = await Utils.isolate(() => _applyBrightness(image: image));
    image = await Utils.isolate(() => _applySaturation(image: image, saturation: -0.2));
    image = await Utils.isolate(() => _applyContrast(image: image, contrast: 0.1));
    image = await Utils.isolate(() => _applyVolume(image: image));
    image = await Utils.isolate(() => _applyHighPass(image: image));
    image = await Utils.isolate(() => _applySepia(image: image, ratio: 0.1));
    image = await Utils.isolate(() => _applyColor(image: image, color: const Color.fromRGBO(228, 130, 225, 0.05)));

    return image;
  }

  Future<Image> applyNatureFilter(Image image) async {
    image = await Utils.isolate(() => _applyBrightness(image: image));
    image = await Utils.isolate(() => _applyContrast(image: image, contrast: 0.05));
    image = await Utils.isolate(() => _applySaturation(image: image, saturation: 0.1));
    image = await Utils.isolate(() => _applyVolume(image: image));
    image = await Utils.isolate(() => _applyHighPass(image: image));
    image = await Utils.isolate(() => _applySepia(image: image, ratio: 0.1));
    image = await Utils.isolate(() => _applyColor(image: image, color: const Color.fromRGBO(255, 160, 25, 0.05)));

    return image;
  }

  Image _applySkinFilter(Image image, Rect rect, Color color) {
    final Image texture = emboss(image.clone());
    final Image colors = gaussianBlur(image.clone(), 10);

    Color optimal = const Color(0xFFFFDDD9);

    int red = (color.red + optimal.red) ~/ 2 + 20;
    int green = (color.green + optimal.green) ~/ 2 + 20;
    int blue = (color.blue + optimal.blue) ~/ 2 + 20;

    rect = Rect.fromCenter(center: rect.center, width: rect.longestSide * 1.5, height: rect.longestSide * 1.5);

    for (int i = rect.left.toInt(); i < rect.right.toInt(); i++) {
      for (int j = rect.top.toInt(); j < rect.bottom.toInt(); j++) {
        int pixel = image.getPixel(i, j);
        int tPixel = texture.getPixel(i, j);
        int cPixel = colors.getPixel(i, j);

        double dist = (rect.center - Offset(i.toDouble(), j.toDouble())).distance;
        double mult = max(0, rect.longestSide / 2 - dist) / rect.longestSide;

        int r = getRed(pixel);
        int g = getGreen(pixel);
        int b = getBlue(pixel);

        int cr = getRed(cPixel);
        int cg = getGreen(cPixel);
        int cb = getBlue(cPixel);

        double factor = 0.5;

        cr = ((1 - factor) * cr + factor * red).round();
        cg = ((1 - factor) * cg + factor * green).round();
        cb = ((1 - factor) * cb + factor * blue).round();

        int color = (cr * 77 + cg * 150 + cb * 29) ~/ (256 * 3);

        factor = 0.8;

        double tr = getRed(tPixel) * factor;
        double tg = getGreen(tPixel) * factor;
        double tb = getBlue(tPixel) * factor;

        int brightness = 0;//(32 * mult).toInt();

        image.setPixelRgba(
          i,
          j,
          _clamp((r * (1 - mult) + mult * (color > _brightness ? (cr + tr) : (cr - tr)) + brightness).round()),
          _clamp((g * (1 - mult) + mult * (color > _brightness ? (cg + tg) : (cg - tg)) + brightness).round()),
          _clamp((b * (1 - mult) + mult * (color > _brightness ? (cb + tb) : (cb - tb)) + brightness).round()),
          getAlpha(pixel),
        );
      }
    }
    return image;
  }

  bool isMonochrome({required Image image, Color? middle}) {
    int pixel = 0;

    int r;
    int g;
    int b;

    middle ??= const Color(0xff000000);

    int rMiddle = middle.red;
    int gMiddle = middle.green;
    int bMiddle = middle.blue;

    int maxMiddleDif = 0;

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);

        r = getRed(pixel);
        g = getGreen(pixel);
        b = getBlue(pixel);

        maxMiddleDif = max(maxMiddleDif, ((r - rMiddle).abs() - (g - gMiddle).abs()).abs());
        maxMiddleDif = max(maxMiddleDif, ((r - rMiddle).abs() - (b - bMiddle).abs()).abs());
        maxMiddleDif = max(maxMiddleDif, ((b - bMiddle).abs() - (g - gMiddle).abs()).abs());
      }
    }

    return maxMiddleDif < 25;
  }

  Image _applySepia({required Image image, double ratio = 0.0}) {
    int pixel = 0;

    int r;
    int g;
    int b;

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);

        r = getRed(pixel);
        g = getGreen(pixel);
        b = getBlue(pixel);

        image.setPixelRgba(
          i,
          j,
          _clamp((r * (1 - 0.607 * ratio) + g * 0.769 * ratio + b * 0.189 * ratio).round()),
          _clamp((r * 0.349 * ratio + g * (1 - 0.314 * ratio) + b * 0.168 * ratio).round()),
          _clamp((r * 0.272 * ratio + g * 0.534 * ratio + b * (1 - 0.869 * ratio)).round()),
          getAlpha(pixel),
        );
      }
    }

    return image;
  }

  Image _applyVolume({required Image image}) {
    int pixel = 0;
    int brightness = 0;

    int r;
    int g;
    int b;

    int dif = 0;

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);

        r = getRed(pixel);
        g = getGreen(pixel);
        b = getBlue(pixel);

        brightness = (r * 77 + g * 150 + b * 29) ~/ (256 * 3);

        if (brightness > 255 || brightness < 0) {
          dif = 0;
        } else if (brightness > _brightness) {
          int middle = (255 - _brightness) ~/ 2;
          dif = ((1 - (brightness - middle).abs() / middle) * 25).toInt();
        } else {
          int middle = (_brightness - 0) ~/ 2;
          dif = (((brightness - middle).abs() / middle - 1) * 25).toInt();
        }

        image.setPixelRgba(
          i,
          j,
          _clamp(r + dif),
          _clamp(g + dif),
          _clamp(b + dif),
          getAlpha(pixel),
        );
      }
    }

    return image;
  }

  Image _applyBrightness({required Image image}) {
    int pixel = 0;
    int middle = 0;
    int white = 0;
    int black = 255;
    int brightness = 0;

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);
        brightness = (getRed(pixel) * 77 + getGreen(pixel) * 150 + getBlue(pixel) * 29) ~/ (256 * 3);
        white = max(white, brightness);
        black = min(black, brightness);
        middle += brightness;
      }
    }

    middle ~/= (image.width * image.height);
    middle = _brightness + ((255 - white - black)) * (_brightness - middle).abs() ~/ _brightness;

    adjustColor(
      image,
      /*blacks: getColor(black, black, black),*/ mids:
          getColor(middle, middle, middle), /*whites: getColor(white, white, white)*/
    );
    return image;
  }

  Image _applyHighPass({required Image image}) {
    return convolution(image, _highPass);
  }

  Image _applySharpen({required Image image}) {
    return convolution(image, _sharpen);
  }

  Image _applySmooth({required Image image}) {
    return smooth(image, 0.2);
  }

  Image _applyEmboss({required Image image}) {
    return emboss(image);
  }

  Image _applyContrast({required Image image, double contrast = 0.0}) {
    int pixel;

    int r;
    int g;
    int b;

    contrast *= 255;
    double factor = (259 * (contrast + 255)) / (255 * (259 - contrast));

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);

        r = getRed(pixel);
        g = getGreen(pixel);
        b = getBlue(pixel);

        image.setPixelRgba(
          i,
          j,
          _clamp((factor * (r - 128) + 128).round()),
          _clamp((factor * (g - 128) + 128).round()),
          _clamp((factor * (b - 128) + 128).round()),
          getAlpha(pixel),
        );
      }
    }
    return image;
  }

  Image _applySaturation({required Image image, double saturation = 0.0}) {
    int pixel;

    int r;
    int g;
    int b;

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);

        r = getRed(pixel);
        g = getGreen(pixel);
        b = getBlue(pixel);

        num gray = 0.2989 * r + 0.5870 * g + 0.1140 * b;

        image.setPixelRgba(
          i,
          j,
          _clamp((-gray * saturation + r * (1 + saturation)).round()),
          _clamp((-gray * saturation + g * (1 + saturation)).round()),
          _clamp((-gray * saturation + b * (1 + saturation)).round()),
          getAlpha(pixel),
        );
      }
    }
    return image;
  }

  Image _applyScale({required Image image, double red = 1.0, double green = 1.0, double blue = 1.0}) {
    int pixel;

    int r;
    int g;
    int b;

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);

        r = getRed(pixel);
        g = getGreen(pixel);
        b = getBlue(pixel);

        image.setPixelRgba(
          i,
          j,
          _clamp((r * red).round()),
          _clamp((g * green).round()),
          _clamp((b * blue).round()),
          getAlpha(pixel),
        );
      }
    }
    return image;
  }

  Image _applyColor({required Image image, required Color color}) {
    int red = (color.red * color.opacity).toInt();
    int green = (color.green * color.opacity).toInt();
    int blue = (color.blue * color.opacity).toInt();

    int pixel;

    int r;
    int b;
    int g;

    for (int i = 0; i < image.width; i++) {
      for (int j = 0; j < image.height; j++) {
        pixel = image.getPixel(i, j);

        r = getRed(pixel);
        g = getGreen(pixel);
        b = getBlue(pixel);

        image.setPixelRgba(
          i,
          j,
          _clamp((r + red).round()),
          _clamp((g + green).round()),
          _clamp((b + blue).round()),
          getAlpha(pixel),
        );
      }
    }
    return image;
  }

  int _clamp(int x) => x.clamp(0, 255);
}
