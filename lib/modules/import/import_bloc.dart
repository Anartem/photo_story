import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image/image.dart' hide Color;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_story/bl/data_holder.dart';
import 'package:photo_story/bl/use_cases/colorize_use_case.dart';
import 'package:photo_story/bl/use_cases/download_use_case.dart';
import 'package:photo_story/bl/use_cases/filter_use_case.dart';
import 'package:photo_story/bl/use_cases/image_converter_use_case.dart';
import 'package:photo_story/bl/use_cases/image_face_use_case.dart';
import 'package:photo_story/bl/use_cases/image_label_use_case.dart';
import 'package:photo_story/bl/use_cases/palette_use_case.dart';
import 'package:photo_story/bl/use_cases/upscale_use_case.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/models/process_model.dart';
import 'package:photo_story/modules/home/home_bloc.dart';

class ImportBloc extends Disposable {
  final ImageConverterUseCase _imageConverterUseCase;
  final PaletteUseCase _paletteUseCase;
  final UpscaleUseCase _upscaleUseCase;
  final DownloadUseCase _downloadUseCase;
  final ImageLabelUseCase _imageLabelUseCase;
  final ImageFaceUseCase _imageFaceUseCase;
  final ColorizeUseCase _colorizeUseCase;
  final FilterUseCase _filterUseCase;

  final HomeBloc _homeBloc;

  final DataHolder<List<ProcessModel>> imageHolder = DataHolder()..complete([]);

  bool _busy = false;

  ImportBloc(
    this._imageConverterUseCase,
    this._paletteUseCase,
    this._upscaleUseCase,
    this._downloadUseCase,
    this._imageFaceUseCase,
    this._imageLabelUseCase,
    this._filterUseCase,
    this._colorizeUseCase,
    this._homeBloc,
  );

  void import() {
    imageHolder.progress();

    ImagePicker()
        .pickMultiImage()
        .then((list) => list?.map(_convert).toList())
        .then((list) => <ProcessModel>[...imageHolder.lastValue ?? [], ...list ?? []])
        .then((list) => imageHolder.complete(list))
        .then((_) => _processNext())
        .catchError((error) => imageHolder.error());
  }

  Future<String> get _cacheDir async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  ProcessModel _convert(XFile file) {
    return ProcessModel(path: file.path);
  }

  void _processNext() {
    final List<ProcessModel> list = imageHolder.lastValue ?? [];
    if (!_busy && list.isNotEmpty) {
      _busy = true;
      _process(list.first);
    }
  }

  Future<void> _process(ProcessModel model) async {
    model = await _decode(model);
    model = await _palette(model);
    model = await _colorize(model);
    model = await _labelDetection(model);
    model = await _faceDetection(model);
    model = await _skinCorrection(model);
    model = await _colorCorrection(model);
    model = await _upscale(model);
    model = await _palette(model);

    _finish(model);
    _processNext();
  }

  Future<ProcessModel> _decode(ProcessModel model) async {
    Image image = await _imageConverterUseCase.decode(model.path);

    model.image = image;
    model.width = image.width;
    model.height = image.height;

    return model;
  }

  Future<ProcessModel> _upscale(ProcessModel model) async {
    assert(model.image != null);

    int width = max(model.image!.width, model.image!.height);
    int height = min(model.image!.width, model.image!.height);

    if (width < 1920 && height < 1080) {
      model = await _upscaleUseCase
          .upscale(model.path, 4)
          .then((url) => _downloadUseCase.download(url, model.path))
          .then((_) => _decode(model))
          .catchError((error) {
            return model;
          });
    }

    return model;
  }

  Future<ProcessModel> _colorCorrection(ProcessModel model) async {
    assert(model.image != null);

    String corrected = await _imageConverterUseCase.encode(
      "${await _cacheDir}$separator${basenameWithoutExtension(model.path)}1.jpg",
      model.faces?.isNotEmpty == true
          ? await _filterUseCase.applyPortraitFilter(model.image!)
          : await _filterUseCase.applyNatureFilter(model.image!),
    );

    File(model.path).deleteSync();

    model
      ..originalPath = model.path
      ..path = corrected;

    return model;
  }

  Future<ProcessModel> _palette(ProcessModel model) async {
    assert(model.image != null);

    model.colors = await _paletteUseCase.getPalette(model.image!);
    return model;
  }

  Future<ProcessModel> _colorize(ProcessModel model) async {
    assert(model.image != null);

    bool isMonochrome = _filterUseCase.isMonochrome(image: model.image!, middle: model.colors?.first);

    if (model.image != null && isMonochrome) {
      String corrected = await _imageConverterUseCase.encode(
        "${await _cacheDir}$separator${basename(model.path)}_.jpg",
        model.image!,
      );

      model
        ..originalPath = model.path
        ..path = corrected;

      model = await _colorizeUseCase
          .colorize(corrected)
          .then((url) => _downloadUseCase.download(url, model.path))
          .then((_) => _decode(model))
          .catchError((error) {
            return model;
          });
    }

    return model;
  }

  Future<ProcessModel> _labelDetection(ProcessModel model) async {
    model.labels = await _imageLabelUseCase.getLabels(model.path);
    return model;
  }

  Future<ProcessModel> _faceDetection(ProcessModel model) async {
    model.faces = await _imageFaceUseCase.getFaces(model.path);
    return model;
  }

  Future<ProcessModel> _skinCorrection(ProcessModel model) async {
    assert(model.image != null);

    if (model.faces?.isNotEmpty == true) {
      for (var face in model.faces!) {
        List<Color> colors = await _paletteUseCase.getPalette(model.image!, face.boundingBox, 2);

        if (colors.isNotEmpty) {
          final Image image = await _filterUseCase.applySkinFilter(model.image!, face.boundingBox, colors.first);

          String corrected = await _imageConverterUseCase.encode(
            "${await _cacheDir}$separator${basenameWithoutExtension(model.path)}2.jpg",
            image,
          );

          File(model.path).deleteSync();

          model
            ..originalPath = model.path
            ..path = corrected;
        }
      }
    }
    return model;
  }

  void _finish(ProcessModel model) {
    final List<ProcessModel> list = imageHolder.lastValue ?? [];
    if (list.isNotEmpty) {
      list.removeAt(0);
    }
    imageHolder.complete(list);
    _homeBloc.add(ImageModel(model));
    _busy = false;
  }

  @override
  void dispose() {
    imageHolder.dispose();
  }
}
