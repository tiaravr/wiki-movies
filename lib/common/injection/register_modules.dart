import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wiki_movies/common/network/http_client.dart' as client;

@module
abstract class RegisterModules {
  @lazySingleton
  Dio createDio() => client.createDio();
}
