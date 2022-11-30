import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/models/page_model.dart';

class ImageTagUseCase implements Disposable {
  PageModel getPage(List<ImageModel> list) {
    list.sort((image1, image2) {
      if (image1.aspectRatio == 1) {
        return -1;
      }

      if (image2.aspectRatio == 1) {
        return 1;
      }

      return image1.aspectRatio.compareTo(image2.aspectRatio);
    });

    String tag = "";

    for (ImageModel image in list) {
      tag += _getOrientationTag(image);
    }

    for (ImageModel image in list) {
      tag += _getTitleTag(image);
    }

    for (ImageModel image in list) {
      tag += _getNoteTag(image);
    }

    tag += "_";

    return PageModel(images: list, tag: tag);
  }

  String _getOrientationTag(ImageModel image) => image.aspectRatio > 1
      ? "L"
      : image.aspectRatio < 1
          ? "P"
          : "S";

  String _getTitleTag(ImageModel image) => image.title?.isNotEmpty == true ? "T" : "";

  String _getNoteTag(ImageModel image) => image.note?.isNotEmpty == true ? "N" : "";

  @override
  void dispose() {

  }
}
