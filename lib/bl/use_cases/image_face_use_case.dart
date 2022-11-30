import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class ImageFaceUseCase implements Disposable {
  late final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions());

  Future<List<Face>> getFaces(String path) {
    return _faceDetector
        .processImage(InputImage.fromFile(File(path)));
  }

  @override
  void dispose() {
    _faceDetector.close();
  }
}
