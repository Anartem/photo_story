import 'package:flutter/material.dart';

extension StyleExtension on ThemeData {
  double get borderRadius => 4.0;
  double get cardPadding => 12.0;

  Color get noteCardColor => colorScheme.surfaceTint.withOpacity(0.08);
  Color get onNoteCardColor => colorScheme.onSurface;
  Color get titleColor => colorScheme.primary;
  Color get noteColor => colorScheme.secondary;
  Color get pageColor => colorScheme.surface;

  double getLines(String content, TextStyle style, [double width = double.infinity]) {
    TextPainter painter = TextPainter(
      //textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(text: content, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    return painter.height;
  }
}