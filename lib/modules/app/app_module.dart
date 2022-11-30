import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/modules/home/home_module.dart';
import 'package:photo_story/modules/splash/splash_page.dart';

class AppModule extends Module {
  static const route = "/";

  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(SplashPage.route, child: (_, __) => const SplashPage()),
        ModuleRoute(HomeModule.route, module: HomeModule()),
      ];
}
