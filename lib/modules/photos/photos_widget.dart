import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/bl/data_holder.dart';
import 'package:photo_story/bl/use_cases/storage_use_case.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/image_widget.dart';
import 'package:photo_story/modules/photos/photos_bloc.dart';
import 'package:photo_story/modules/story/ui/page_progress_widget.dart';
import 'package:photo_story/bl/state_extension.dart';
import 'package:share_plus/share_plus.dart';

class PhotosWidget extends WidgetModule {
  final void Function(ImageModel)? onNote;

  PhotosWidget({this.onNote, super.key});

  @override
  List<Bind<Object>> get binds => [
        Bind((i) => StorageUseCase()),
        Bind((i) => PhotosBloc(Modular.get(), Modular.get())),
      ];

  @override
  Widget get view => _PhotosWidget(onNote: onNote);
}

class _PhotosWidget extends StatefulWidget {
  final void Function(ImageModel)? onNote;

  const _PhotosWidget({this.onNote, Key? key}) : super(key: key);

  @override
  State<_PhotosWidget> createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<_PhotosWidget> {
  late final PhotosBloc _bloc = Modular.get();
  late final PageController _pageController = PageController(viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.imageHolder.stream,
      initialData: _bloc.imageHolder.last,
      builder: (context, snapshot) {
        DataModel<List<ImageModel>>? data = snapshot.data;
        List<ImageModel> list = data?.value ?? [];
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        ImageWidget(image: list[index]),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit_note_outlined,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            onPressed: () => widget.onNote?.call(list[index]),
                            iconSize: 36,
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                          ),
                        )
                      ],
                    ),
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
                  onPressed: () => _onSave(share: false),
                  child: const Text("Save"),
                ),
                PagerProgressWidget(
                  begin: colorScheme.primary,
                  end: colorScheme.outline,
                  controller: _pageController,
                  itemCount: list.length,
                ),
                ElevatedButton(
                  onPressed: () => _onSave(share: true),
                  child: const Text("Share"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onSave({bool share = false}) {
    final List<ImageModel>? list = _bloc.imageHolder.lastValue;
    ImageModel? image = list?.elementAt(_pageController.page?.round() ?? 0);

    if (image == null) {
      return;
    }

    if (_bloc.permissionHolder.lastValue == true) {
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      Future.delayed(const Duration(milliseconds: 300)).then((_) => _bloc.savePhoto(image.path)).then((path) {
        Navigator.of(context).maybePop();
        if (share) {
          Share.share(path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Photo successfully saved to $path")),
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Storage permission missing"),
          content: const Text("Allow app to use storage to save photos in the phone gallery"),
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
