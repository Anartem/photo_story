import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_story/bl/state_extension.dart';
import 'package:photo_story/modules/home/home_module.dart';

class SplashPage extends StatefulWidget {
  static const route = "/splash";

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const Duration _animationDuration = Duration(milliseconds: 2000);
  static const Duration _splashDuration = Duration(milliseconds: 3000);

  final ValueNotifier<double> _notifier = ValueNotifier(0.0);
  late final Timer _timer;

  @override
  void initState() {
    _timer = Timer(_splashDuration, _openNext);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FlutterNativeSplash.remove();
      _notifier.value = 1.0;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<double>(
        valueListenable: _notifier,
        builder: (_, value, child) => Container(
          color: colorScheme.surface,
          child: AnimatedOpacity(
            opacity: value,
            duration: _animationDuration,
            child: child,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/svg/logo.svg", color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                "Photo Story".toUpperCase(),
                style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Keep your best memories",
                style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openNext() {
    Modular.to.pushReplacementNamed(HomeModule.route);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
