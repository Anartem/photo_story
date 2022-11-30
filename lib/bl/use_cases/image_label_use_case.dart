import 'dart:async';
import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ImageLabelUseCase implements Disposable {
  late final ImageLabeler _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.75));

  Future<List<String>> getLabels(String path) {
    return _imageLabeler
        .processImage(InputImage.fromFile(File(path)))
        .then((list) => list.map((label) => label.label).toList());
  }

  @override
  void dispose() {
    _imageLabeler.close();
  }
}