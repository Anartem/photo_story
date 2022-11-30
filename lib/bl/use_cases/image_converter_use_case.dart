import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart';

class ImageConverterUseCase {
  Future<Image> decode(String path) {
    return isolate((port) => port.send(_decode(path)));
  }

  Future<String> encode(String path, Image image) {
    return isolate((port) => port.send(_encode(path, image)));
  }

  Image _decode(String path) {
    return decodeImage(File(path).readAsBytesSync())!;
  }

  String _encode(String path, Image image) {
    final List<int> list = encodeJpg(image, quality: 80);
    File(path).writeAsBytesSync(list, flush: true);
    return path;
  }

  Future<T> isolate<T>(Function(SendPort) function) async {

    final ReceivePort port = ReceivePort();

    Isolate.spawn(
      function,
      port.sendPort,
    );

    return port.first.then((value) => value as T);
  }
}