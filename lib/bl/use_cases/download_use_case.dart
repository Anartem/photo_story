import 'package:dio/dio.dart';

class DownloadUseCase {
  final Dio _dio;

  DownloadUseCase(this._dio);

  Future<Response> download(String url, String path) async {
    return _dio.download(
        url,
        path,
    );
  }
}