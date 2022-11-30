import 'dart:ui';

import 'package:photo_story/models/process_model.dart';

class ImageModel {
  final String path;
  final int width;
  final int height;
  final List<Color> colors;

  String? title; // = "The physical world or universe";
  String? note; // = """Within the various uses of the word today, "nature" often refers to geology and wildlife. Nature can refer to the general realm of living plants and animals, and in some cases to the processes associated with inanimate objects—the way that particular types of things exist and change of their own accord, such as the weather and geology of the Earth.""";

  ImageModel(ProcessModel model)
      : assert(model.width != null && model.height != null && model.colors != null),
        path = model.path,
        width = model.width!,
        height = model.height!,
        colors = model.colors!;

  double get aspectRatio => width / height;

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
