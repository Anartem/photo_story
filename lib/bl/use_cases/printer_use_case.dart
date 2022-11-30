import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path/path.dart';
import 'package:photo_story/bl/use_cases/widget_to_image_use_case.dart';
import 'package:photo_story/bl/utils.dart';

class PrinterUseCase {
  static const _appLabel = "Photo Story App";
  static const _size = Size(1024, 1024);

  final WidgetToImageUseCase _widgetToImageUseCase;

  PrinterUseCase(this._widgetToImageUseCase);

  Future<File> printPdf({required List<Widget> widgets}) async {
    final pdf.Document document = pdf.Document(
      title: "Photo story",
      author: _appLabel,
      creator: _appLabel,
    );

    for (Widget widget in widgets) {
      widget = MaterialApp(home: Scaffold(body: widget), debugShowCheckedModeBanner: false);
      pdf.Page page = await _widgetToImageUseCase.toImage(widget: widget, size: _size).then(_convert);
      document.addPage(page);
    }

    Uint8List buffer = await Utils.isolate(() => document.save());
    File file = await _prepareFile("${DateTime.now().millisecondsSinceEpoch}");
    file.writeAsBytesSync(buffer);

    return file;
  }

  pdf.Page _convert(Uint8List buffer) {
    return pdf.Page(
      pageFormat: const PdfPageFormat(
        21.0 * PdfPageFormat.cm,
        21.0 * PdfPageFormat.cm,
        marginAll: 0,
      ),
      build: (context) => pdf.Center(
        child: pdf.Image(
          pdf.MemoryImage(buffer),
        ),
      ),
    );
  }

  Future<File> _prepareFile(String name) async {
    String dirPath;

    if (Platform.isIOS) {
      dirPath = (await getApplicationDocumentsDirectory()).path;
    } else {
      dirPath = (await getExternalStorageDirectory())?.path ?? "";
    }

    dirPath += "${separator}pdf";

    final Directory dir = Directory(dirPath);

    if (!dir.existsSync()) {
      dir.createSync();
    }

    String filePath = "$dirPath$separator$name.pdf";
    final file = File(filePath);

    if (!file.existsSync()) {
      file.createSync();
    }

    return file;
  }
}
