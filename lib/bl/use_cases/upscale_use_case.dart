import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class UpscaleUseCase {
  final Dio _dio;

  UpscaleUseCase(this._dio);

  Future<String> upscale(String path, int scale) async {
    final Uint8List bytes = await File(path).readAsBytes();
    String data = base64.encode(bytes);

    Response response = await _dio.post(
      "https://super-image1.p.rapidapi.com/run",
      data: {"image": data, "upscale": scale},
      options: Options(headers: {
        "content-type": "application/json",
        "X-RapidAPI-Key": "API_KEY",
        "X-RapidAPI-Host": "super-image1.p.rapidapi.com",
      }),
    );

    return response.data["output_url"];
  }
}
