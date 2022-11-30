import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/bl/data_holder.dart';
import 'package:photo_story/bl/use_cases/image_tag_use_case.dart';
import 'package:photo_story/bl/use_cases/printer_use_case.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/models/page_model.dart';
import 'package:photo_story/modules/home/home_bloc.dart';
import 'package:photo_story/modules/story/ui/pages/page_widget.dart';

class StoryBloc extends Disposable {
  final ImageTagUseCase _imageTagUseCase;
  final PrinterUseCase _printerUseCase;

  final HomeBloc _bloc;

  final DataHolder<List<PageModel>> pageHolder = DataHolder();

  DataHolder<bool> get permissionHolder => _bloc.permissionHolder;

  late final StreamSubscription _imageSubscription;

  StoryBloc(this._imageTagUseCase, this._printerUseCase, this._bloc) {
    process(_bloc.imageHolder.lastValue);
    _imageSubscription = _bloc.imageHolder.stream.listen((data) => process(data.value));
  }

  void process(final List<ImageModel>? list) {
    if (list == null || list.isEmpty) return;

    pageHolder.progress();

    final List<PageModel> pages = [];

    int i = 0;
    while (i < list.length) {
      ImageModel image1 = list[i];

      if (i + 1 < list.length) {
        ImageModel image2 = list[i + 1];
        PageModel page = _imageTagUseCase.getPage([image1, image2]);

        if (PageWidget.supported.any((tag) => tag.contains(page.tag))) {
          pages.add(page);
          i += 2;
        } else {
          pages.add(_imageTagUseCase.getPage([image1]));
          i += 1;
        }
      } else {
        pages.add(_imageTagUseCase.getPage([image1]));
        i += 1;
      }
    }

    pageHolder.complete(pages);
  }

  Future<String> print() {
    List<Widget> widgets = pageHolder.lastValue?.map((page) => PageWidget(page: page)).toList() ?? [];
    return _printerUseCase.printPdf(widgets: widgets).then((file) => file.path);
  }

  @override
  void dispose() {
    pageHolder.dispose();
    _imageSubscription.cancel();
  }
}