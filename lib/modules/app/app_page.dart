import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppPage extends StatelessWidget {
  static const defaultColor = Colors.orange;

  const AppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme light = lightDynamic ?? ColorScheme.fromSeed(
          seedColor: defaultColor,
          brightness: Brightness.light,
        );

        ColorScheme dark = darkDynamic ?? ColorScheme.fromSeed(
          seedColor: defaultColor,
          brightness: Brightness.dark,
        );

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true, colorScheme: light, fontFamily: "RobotoFlex"),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: dark, fontFamily: "RobotoFlex"),
          themeMode: ThemeMode.system,
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
          builder: (context, child) {
            ColorScheme colorScheme = Theme.of(context).colorScheme;

            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                systemNavigationBarColor: colorScheme.surface,
                systemNavigationBarIconBrightness: colorScheme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
              ),
            );
            return child!;
          },
        );
      },
    );
  }
}
