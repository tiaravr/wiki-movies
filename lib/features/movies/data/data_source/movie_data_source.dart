import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:wiki_movies/common/exception/exception.dart';
import 'package:wiki_movies/common/network/http_client.dart';
import 'package:wiki_movies/features/movies/domain/entities/response/movie_list.dart';

@LazySingleton()
class MovieDataSource {
  const MovieDataSource(this._httpServices);

  final HttpServices _httpServices;

  Future<MovieList> getMovies() async {
    try {
      final res = await _httpServices.get(
        path: '/discover/movie',
        queryParam: {
          'api_key': dotenv.get('API_KEY'),
          'include_adult': false,
          'include_video': false,
          'language': 'en-US',
          'page': 1,
          'sort_by': 'popularity.desc',
        },
      );
      if (res.statusCode == 200) {
        return MovieList.fromJson(res.data);
      }
      throw UnknownException('errorCode ::: ${res.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}
