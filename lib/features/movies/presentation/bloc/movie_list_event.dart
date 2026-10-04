part of 'movie_list_bloc.dart';

@immutable
sealed class MovieListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class MovieListFetchEvent extends MovieListEvent {}

final class MovieListChangeRatingEvent extends MovieListEvent {
  final MovieCategory category;

  MovieListChangeRatingEvent({required this.category});

  @override
  List<Object> get props => [category];
}

final class MovieListSearchEvent extends MovieListEvent {
  final String? searchValue;

  MovieListSearchEvent({this.searchValue});

  @override
  List<Object> get props => [searchValue ?? ''];
}
