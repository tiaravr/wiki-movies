import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_movies/common/injection/injection.dart';
import 'package:wiki_movies/features/movies/domain/entities/request/category.dart';
import 'package:wiki_movies/features/movies/domain/entities/response/movie.dart';
import 'package:wiki_movies/features/movies/presentation/bloc/movie_list_bloc.dart';
import 'package:wiki_movies/features/movies/presentation/widget/empty_list_widget.dart';
import 'package:wiki_movies/features/movies/presentation/widget/failure_widget.dart';
import 'package:wiki_movies/features/movies/presentation/widget/loading_list_widget.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MovieListBloc>()..add(MovieListFetchEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Wiki Movies',
            style: TextStyle(color: Colors.white, fontWeight: .w700),
          ),
          backgroundColor: Colors.blue,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: .symmetric(horizontal: 8.0, vertical: 12.0),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value) {
                    context.read<MovieListBloc>().add(
                      MovieListSearchEvent(searchValue: value),
                    );
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Search movie title',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: ValueListenableBuilder(
                      valueListenable: _textEditingController,
                      builder: (context, value, _) {
                        if (value.text.isEmpty) {
                          return SizedBox.shrink();
                        }
                        return InkWell(
                          onTap: () {
                            _textEditingController.clear();
                            context.read<MovieListBloc>().add(
                              MovieListSearchEvent(),
                            );
                          },
                          child: const Icon(Icons.close),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<MovieListBloc, MovieListState>(
                builder: (context, state) {
                  return Padding(
                    padding: .symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter by Rating',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontWeight: .w700),
                        ),
                        Text(
                          'Totals = ${(state.selectedCategory != MovieCategory.all || state.searchQuery.isNotEmpty) ? state.filteredList?.length ?? 0 : state.movieList.results?.length ?? 0}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontWeight: .w700),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: .only(top: 8),
                height: 32,
                child: BlocBuilder<MovieListBloc, MovieListState>(
                  builder: (context, state) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: MovieCategory.values.length,
                      padding: .symmetric(horizontal: 8),
                      separatorBuilder: (_, _) => SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final category = MovieCategory.values[index];
                        final isSelected = category == state.selectedCategory;
                        return InkWell(
                          onTap: () {
                            context.read<MovieListBloc>().add(
                              MovieListChangeRatingEvent(category: category),
                            );
                          },
                          borderRadius: .all(.circular(16)),
                          child: Container(
                            alignment: .center,
                            padding: .symmetric(horizontal: 24, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: .all(.circular(16)),
                              border: .all(color: Colors.grey[400]!),
                              color: isSelected
                                  ? Colors.blue[100]
                                  : Colors.white,
                            ),
                            child: Text(category.label),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
          body: BlocBuilder<MovieListBloc, MovieListState>(
            builder: (context, state) {
              if (state.fetchStatus == .loading) {
                return const LoadingListWidget();
              }

              if (state.fetchStatus == .empty) {
                return const EmptyListWidget();
              }

              if (state.fetchStatus == .failure) {
                return FailureWidget(
                  errorMessage:
                      state.errorMessage ??
                      'Terjadi kesalahan, silakan coba lagi.',
                  onRetry: () {
                    context.read<MovieListBloc>().add(MovieListFetchEvent());
                  },
                );
              }

              if (state.fetchStatus == .success) {
                return _buildMovieList(
                  state.filteredList ?? state.movieList.results ?? [],
                );
              }

              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  ListView _buildMovieList(List<Movie> movieList) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemBuilder: (context, index) {
        Movie movie = movieList[index];
        return ListTile(
          title: Text(movie.title ?? ''),
          subtitle: Text(movie.releaseDate ?? ''),
          leading: Image.network(
            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            width: 50,
            height: 75,
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 8),
      itemCount: movieList.length,
    );
  }
}
