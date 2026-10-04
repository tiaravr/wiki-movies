part of 'movie_list_bloc.dart';

enum FetchStatus { initial, loading, empty, success, failure }

@immutable
final class MovieListState extends Equatable {
  final MovieList movieList;
  final List<Movie>? filteredList;
  final FetchStatus fetchStatus;
  final MovieCategory selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const MovieListState({
    this.movieList = const MovieList(),
    this.filteredList,
    this.fetchStatus = .initial,
    this.selectedCategory = .all,
    this.searchQuery = '',
    this.errorMessage,
  });

  MovieListState copyWith({
    MovieList? movieList,
    List<Movie>? filteredList,
    FetchStatus? fetchStatus,
    MovieCategory? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return MovieListState(
      movieList: movieList ?? this.movieList,
      filteredList: filteredList,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    movieList,
    filteredList,
    fetchStatus,
    selectedCategory,
    searchQuery,
    errorMessage,
  ];
}
