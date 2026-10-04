import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wiki_movies/common/exception/exception.dart';
import 'package:wiki_movies/features/movies/domain/entities/request/category.dart';
import 'package:wiki_movies/features/movies/domain/entities/response/movie.dart';
import 'package:wiki_movies/features/movies/domain/entities/response/movie_list.dart';
import 'package:wiki_movies/features/movies/domain/repositories/movie_repositories.dart';

part 'movie_list_event.dart';

part 'movie_list_state.dart';

@Injectable()
class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc(this._movieRepositories) : super(MovieListState()) {
    on<MovieListFetchEvent>(_onFetchMovies);
    on<MovieListChangeRatingEvent>(_onChangeRating);
    on<MovieListSearchEvent>(_onSearch);
  }

  final MovieRepositories _movieRepositories;

  Future<void> _onSearch(
    MovieListSearchEvent event,
    Emitter<MovieListState> emit,
  ) async {
    final searchQuery = event.searchValue ?? '';

    emit(
      state.copyWith(
        fetchStatus: .loading,
        filteredList: state.filteredList,
        searchQuery: searchQuery,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 200), () {
      if (searchQuery == state.searchQuery) {
        _emitFilteredMovies(
          emit,
          searchQuery: searchQuery,
          category: state.selectedCategory,
        );
      }
    });
  }

  Future<void> _onChangeRating(
    MovieListChangeRatingEvent event,
    Emitter<MovieListState> emit,
  ) async {
    final category = event.category;

    if (category == state.selectedCategory) {
      return;
    }

    emit(
      state.copyWith(
        selectedCategory: category,
        fetchStatus: .loading,
        filteredList: state.filteredList,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 200), () {
      _emitFilteredMovies(
        emit,
        searchQuery: state.searchQuery,
        category: category,
      );
    });
  }

  void _emitFilteredMovies(
    Emitter<MovieListState> emit, {
    required String searchQuery,
    required MovieCategory category,
  }) {
    if (searchQuery.isEmpty && category == MovieCategory.all) {
      emit(state.copyWith(fetchStatus: .success, filteredList: null));
      return;
    }

    final filteredList = _filterRating(
      movieList: _filterTitle(
        movieList: state.movieList.results ?? [],
        searchQuery: searchQuery,
      ),
      category: category,
    );

    if (filteredList.isEmpty) {
      emit(state.copyWith(fetchStatus: .empty));
    } else {
      emit(state.copyWith(fetchStatus: .success, filteredList: filteredList));
    }
  }

  List<Movie> _filterTitle({
    required List<Movie> movieList,
    required String searchQuery,
  }) {
    if (searchQuery.isEmpty) {
      return movieList;
    }

    final query = searchQuery.toLowerCase();

    return movieList
        .where((movie) => movie.title?.toLowerCase().contains(query) ?? false)
        .toList();
  }

  Future<void> _onFetchMovies(
    MovieListFetchEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(state.copyWith(fetchStatus: .loading));
    try {
      final response = await _movieRepositories.getMovies();

      if (response.results?.isNotEmpty == true) {
        emit(state.copyWith(fetchStatus: .success, movieList: response));

        _emitFilteredMovies(
          emit,
          searchQuery: state.searchQuery,
          category: state.selectedCategory,
        );
      } else {
        emit(state.copyWith(fetchStatus: .empty));
      }
    } on MovieException catch (e) {
      emit(state.copyWith(fetchStatus: .failure, errorMessage: e.errorMessage));
    } catch (e) {
      emit(state.copyWith(fetchStatus: .failure, errorMessage: e.toString()));
    }
  }

  List<Movie> _filterRating({
    required List<Movie> movieList,
    required MovieCategory category,
  }) {
    if (category == MovieCategory.all) {
      return movieList;
    }

    return movieList
        .where((movie) => category.matches(movie.voteAverage))
        .toList();
  }
}
