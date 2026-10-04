import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:wiki_movies/common/exception/exception.dart';

Dio createDio() {
  final dio = Dio(BaseOptions(baseUrl: dotenv.get('ENDPOINT')));
  dio.interceptors.add(
    LogInterceptor(
      request: false,
      requestBody: false,
      requestUrl: false,
      requestHeader: false,
      responseBody: true,
    ),
  );
  return dio;
}

@LazySingleton()
class HttpServices {
  const HttpServices(this._dio);

  final Dio _dio;

  Future<Response> get({Map<String, dynamic>? queryParam, String? path}) async {
    try {
      Response response = await _dio.get(
        path != null ? '/$path' : '',
        queryParameters: queryParam,
      );
      debugPrint(response.data.toString());
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw TimeoutException('Connection Error');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw TimeoutException('Connection TimeOut');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException('Receive TimeOut');
      } else if (e.type == DioExceptionType.transformTimeout) {
        throw TimeoutException('Transform TimeOut');
      } else {
        throw UnknownException(e.message.toString());
      }
    }
  }
}
