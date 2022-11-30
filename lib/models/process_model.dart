import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' hide Color;

class ProcessModel {
  String path;
  Image? image;
  String? originalPath;

  int? width;
  int? height;

  List<String>? labels;
  List<Color>? colors;
  List<Face>? faces;

  double? brightness;
  double? hue;
  double? saturation;

  String? title; // = "The physical world or universe";
  String? note; // = """Within the various uses of the word today, "nature" often refers to geology and wildlife. Nature can refer to the general realm of living plants and animals, and in some cases to the processes associated with inanimate objects—the way that particular types of things exist and change of their own accord, such as the weather and geology of the Earth.""";

  ProcessModel({required this.path});

  double get aspectRatio => width == 0 || height == 0 ? 1 : width! / height!;

  List<String> get tags => [
        aspectRatio == 1
            ? "S"
            : aspectRatio > 1
                ? "L"
                : "P",
        if (title != null) "T",
        if (note != null) "N",
      ];
}
