import 'package:flutter/material.dart';

extension StateExtension on State {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  TextTheme get textTheme => Theme.of(context).textTheme;

  void showSnackBar(String content) {
    TextStyle? style = Theme.of(context).textTheme.bodyMedium;

    TextPainter painter = TextPainter(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(text: content, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          content,
          style: style?.copyWith(
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
        width: painter.width + 2 * 16,
      ),
    );
  }
}
