import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/bl/data_holder.dart';
import 'package:photo_story/bl/use_cases/colorize_use_case.dart';
import 'package:photo_story/bl/use_cases/download_use_case.dart';
import 'package:photo_story/bl/use_cases/filter_use_case.dart';
import 'package:photo_story/bl/use_cases/image_converter_use_case.dart';
import 'package:photo_story/bl/use_cases/image_face_use_case.dart';
import 'package:photo_story/bl/use_cases/image_label_use_case.dart';
import 'package:photo_story/bl/use_cases/image_tag_use_case.dart';
import 'package:photo_story/bl/use_cases/palette_use_case.dart';
import 'package:photo_story/bl/use_cases/upscale_use_case.dart';
import 'package:photo_story/models/process_model.dart';
import 'package:photo_story/modules/import/import_bloc.dart';

class ImportWidget extends WidgetModule {
  static const route = "/import";

  ImportWidget({super.key});

  @override
  List<Bind<Object>> get binds => [
        Bind((i) => ImageConverterUseCase()),
        Bind((i) => PaletteUseCase()),
        Bind((i) => UpscaleUseCase(Modular.get())),
        Bind((i) => DownloadUseCase(Modular.get())),
        Bind((i) => ImageLabelUseCase()),
        Bind((i) => ImageFaceUseCase()),
        Bind((i) => FilterUseCase()),
        Bind((i) => ColorizeUseCase(Modular.get())),
        Bind((i) => ImageTagUseCase()),
        Bind((i) => ImportBloc(
              Modular.get(),
              Modular.get(),
              Modular.get(),
              Modular.get(),
              Modular.get(),
              Modular.get(),
              Modular.get(),
              Modular.get(),
              Modular.get(),
            )),
      ];

  @override
  Widget get view => const _ImportWidget();
}

class _ImportWidget extends StatefulWidget {
  const _ImportWidget({Key? key}) : super(key: key);

  @override
  State<_ImportWidget> createState() => _ImportWidgetState();
}

class _ImportWidgetState extends State<_ImportWidget> {
  late final ImportBloc _bloc = Modular.get();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.imageHolder.stream,
      initialData: _bloc.imageHolder.last,
      builder: (context, snapshot) {
        final DataModel<List<ProcessModel>>? data = snapshot.data;
        final List<ProcessModel> list = data?.value ?? [];

        if (list.isEmpty) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: data?.state == DataState.progress ? null : _bloc.import,
              child: const Text("Import images"),
            ),
          );
        }

        return SizedBox(
          height: 100,
          child: ListView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                  list.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.file(
                                  File(list[index].path),
                                  fit: BoxFit.cover,
                                  frameBuilder: (context, child, frame, wasLoaded) {
                                    return wasLoaded || frame != null
                                        ? child
                                        : Container(color: Theme.of(context).colorScheme.surfaceVariant);
                                  },
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                            if (index == 0) const CircularProgressIndicator(),
                          ],
                        ),
                      )),
              IconButton(
                onPressed: data?.state == DataState.progress ? null : _bloc.import,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }
}
