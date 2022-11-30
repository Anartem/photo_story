import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:photo_story/bl/data_holder.dart';
import 'package:photo_story/models/image_model.dart';

class HomeBloc implements Disposable {
  final DataHolder<List<ImageModel>> imageHolder = DataHolder()..complete([]);
  final DataHolder<bool> permissionHolder = DataHolder()..complete(false);

  void add(ImageModel image) {
    final List<ImageModel> images = [
      ...imageHolder.lastValue ?? [],
      image,
    ];
    imageHolder.complete(images);
  }

  void update(ImageModel image) {
    final List<ImageModel> images = imageHolder.lastValue ?? [];
    int index = images.indexWhere((element) => element.path == image.path);
    if (index != -1) {
      images[index] = image;
      imageHolder.complete(images);
    }
  }

  void checkPermission(bool request) async {
    PermissionStatus status = await Permission.storage.status;
    if (status == PermissionStatus.denied && request) {
      status = await Permission.storage.request();
    }

    permissionHolder.complete(status == PermissionStatus.granted);
  }

  @override
  void dispose() {
    imageHolder.dispose();
  }
}
