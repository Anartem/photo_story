import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_story/modules/app/app_module.dart';
import 'package:photo_story/modules/app/app_page.dart';
import 'package:photo_story/modules/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Modular.setInitialRoute(SplashPage.route);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ModularApp(
        module: AppModule(),
        child: const AppPage(),
      ),
    ),
  );
}