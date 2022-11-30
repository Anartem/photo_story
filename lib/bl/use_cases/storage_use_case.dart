import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class StorageUseCase {
  StorageUseCase();

  Future<String> get _storageDir async {
    final Directory? directory = await getExternalStorageDirectory();
    return directory?.path ?? "";
  }

  Future<String> save(String path) async {
    String dir = await _storageDir;
    File file = File("$dir$separator${DateTime.now().millisecondsSinceEpoch}.jpg");
    await File(path).copy(file.path);
    return file.path;
  }
}