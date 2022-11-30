import 'package:dio/dio.dart';

class ColorizeUseCase {
  final Dio _dio;

  ColorizeUseCase(this._dio);

  Future<String> colorize(String path) async {
    Response response = await _dio.post(
      "https://techhk.aoscdn.com/api/tasks/visual/colorization",
      data: FormData.fromMap({"file": await MultipartFile.fromFile(path), "sync": 1}),
      options: Options(headers: {
        "X-API-KEY": "API_KEY",
      }),
    );

    return response.data["data"]["image"];
  }
}
