import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/bl/data_holder.dart';
import 'package:photo_story/bl/use_cases/storage_use_case.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/home/home_bloc.dart';

class PhotosBloc extends Disposable {
  final HomeBloc _bloc;
  final StorageUseCase _storageUseCase;

  DataHolder<List<ImageModel>> get imageHolder => _bloc.imageHolder;
  DataHolder<bool> get permissionHolder => _bloc.permissionHolder;

  PhotosBloc(this._storageUseCase, this._bloc);

  Future<String> savePhoto(String path) {
    return _storageUseCase.save(path);
  }

  @override
  void dispose() {
  }
}