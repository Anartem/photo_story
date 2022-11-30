import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/models/image_model.dart';
import 'package:photo_story/modules/home/home_bloc.dart';
import 'package:photo_story/modules/import/import_widget.dart';
import 'package:photo_story/modules/note/note_page.dart';
import 'package:photo_story/modules/photos/photos_widget.dart';
import 'package:photo_story/modules/story/story_widget.dart';

class HomePage extends WidgetModule {
  static const route = "/home";

  HomePage({super.key});

  @override
  List<Bind<Object>> get binds => [
        Bind((i) => HomeBloc()),
      ];

  @override
  Widget get view => const _HomePage();
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> with WidgetsBindingObserver {
  late final HomeBloc _bloc = Modular.get();

  final ValueNotifier<int> _pageNotifier = ValueNotifier(0);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.checkPermission(true);
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bloc.checkPermission(false);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Story"),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _pageNotifier,
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                child!,
                Center(
                  child: ToggleButtons(
                    isSelected: [
                      value == 0,
                      value == 1,
                    ],
                    constraints: const BoxConstraints(minWidth: 100, minHeight: 48),
                    children: const [
                      Text("Photos"),
                      Text("Book"),
                    ],
                    onPressed: (index) => _pageNotifier.value = index,
                  ),
                ),
                const Divider(),
                if (value == 0) Expanded(child: PhotosWidget(onNote: _onNote)),
                if (value == 1) Expanded(child: StoryWidget()),
              ],
            );
          },
          child: ImportWidget(),
        ),
      ),
    );
  }

  void _onNote(ImageModel image) async {
    NotePageArg? arg = await Modular.to.pushNamed(".${NotePage.route}", arguments: NotePageArg(image));
    if (arg != null) {
      _bloc.update(arg.image);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageNotifier.dispose();
    super.dispose();
  }
}
