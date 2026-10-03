import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio createDio() {
  final dio = Dio(BaseOptions(baseUrl: dotenv.get('BASE_URL')));
  return dio;
}

class HttpServices {
  const HttpServices._();

  static final _dio = createDio();

  static Future<Response> post({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    Response response = await _dio.post(url, data: body);
    debugPrint(response.data.toString());
    return response;
  }

  static Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParam,
    String? path,
  }) async {
    Response response = await _dio.get(
      '$url${path != null ? '/$path' : ''}',
      queryParameters: queryParam,
    );
    debugPrint(response.data.toString());
    return response;
  }
}
