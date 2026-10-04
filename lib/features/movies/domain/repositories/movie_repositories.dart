import 'package:injectable/injectable.dart';
import 'package:wiki_movies/features/movies/data/data_source/movie_data_source.dart';
import 'package:wiki_movies/features/movies/domain/entities/response/movie_list.dart';

@LazySingleton()
class MovieRepositories {
  final MovieDataSource _dataSource;

  MovieRepositories(this._dataSource);

  Future<MovieList> getMovies() async {
    try {
      final result = await _dataSource.getMovies();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
