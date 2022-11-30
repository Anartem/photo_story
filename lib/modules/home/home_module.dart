import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/modules/home/home_page.dart';
import 'package:photo_story/modules/note/note_page.dart';

class HomeModule extends Module {
  static const route = "/home";

  @override
  List<Bind<Object>> get binds => [
        Bind<Dio>((i) => Dio(), onDispose: (dio) => dio.close()),
      ];

  @override
  List<ModularRoute> get routes => [
        RedirectRoute(route, to: "$route/"),
        ChildRoute("/", child: (_, __) => HomePage()),
        ChildRoute(
          NotePage.route,
          child: (_, args) => NotePage(arg: args.data as NotePageArg),
        ),
      ];
}
