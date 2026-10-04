import 'package:wiki_movies/features/movies/domain/entities/response/movie.dart';

class MovieList {
  final int? page;
  final List<Movie>? results;
  final int? totalPages;
  final int? totalResults;

  const MovieList({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) {
    return MovieList(
      page: json['page'],
      results: json['results'] == null
          ? null
          : (json['results'] as List).map((e) => Movie.fromJson(e)).toList(),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}
