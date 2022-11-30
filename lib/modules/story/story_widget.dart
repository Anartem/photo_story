import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/bl/data_holder.dart';
import 'package:photo_story/bl/state_extension.dart';
import 'package:photo_story/bl/use_cases/printer_use_case.dart';
import 'package:photo_story/bl/use_cases/widget_to_image_use_case.dart';
import 'package:photo_story/models/page_model.dart';
import 'package:photo_story/modules/story/story_bloc.dart';
import 'package:photo_story/modules/story/ui/page_progress_widget.dart';
import 'package:photo_story/modules/story/ui/pages/page_widget.dart';
import 'package:printing/printing.dart';

class StoryWidget extends WidgetModule {
  StoryWidget({super.key});

  @override
  List<Bind<Object>> get binds => [
        Bind((i) => WidgetToImageUseCase()),
        Bind((i) => PrinterUseCase(Modular.get())),
        Bind((i) => StoryBloc(Modular.get(), Modular.get(), Modular.get())),
      ];

  @override
  Widget get view => const _StoryWidget();
}

class _StoryWidget extends StatefulWidget {
  const _StoryWidget({Key? key}) : super(key: key);

  @override
  State<_StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<_StoryWidget> {
  late final StoryBloc _bloc = Modular.get();
  late final PageController _pageController = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.pageHolder.stream,
      initialData: _bloc.pageHolder.last,
      builder: (context, snapshot) {
        DataModel<List<PageModel>>? data = snapshot.data;
        List<PageModel> list = data?.value ?? [];
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No images prepared",
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  "Press 'Import images' to add images",
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: colorScheme.surfaceVariant)),
                    child: PageWidget(page: list[index]),
                  ),
                ),
                itemCount: list.length,
              ),
            ),
            const Divider(),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onSave(print: false),
                  child: const Text("Save"),
                ),
                PagerProgressWidget(
                  begin: colorScheme.primary,
                  end: colorScheme.outline,
                  controller: _pageController,
                  itemCount: list.length,
                ),
                ElevatedButton(
                  onPressed: () => _onSave(print: true),
                  child: const Text("Print"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onSave({bool print = false}) {
    final List<PageModel>? list = _bloc.pageHolder.lastValue;

    if (list == null || list.isEmpty) {
      return;
    }

    if (_bloc.permissionHolder.lastValue == true) {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      Future.delayed(const Duration(milliseconds: 300)).then((_) => _bloc.print()).then((path) {
        Navigator.of(context).maybePop();
        if (print) {
          Printing.layoutPdf(onLayout: (_) => File(path).readAsBytesSync());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Pdf is exported to $path")),
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Storage permission missing"),
          content: const Text("Allow app to use storage to export to PDF"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings();
              },
              child: const Text("Settings"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
