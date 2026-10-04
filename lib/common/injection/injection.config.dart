// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:wiki_movies/common/injection/register_modules.dart' as _i259;
import 'package:wiki_movies/common/network/http_client.dart' as _i383;
import 'package:wiki_movies/features/movies/data/data_source/movie_data_source.dart'
    as _i461;
import 'package:wiki_movies/features/movies/domain/repositories/movie_repositories.dart'
    as _i1056;
import 'package:wiki_movies/features/movies/presentation/bloc/movie_list_bloc.dart'
    as _i750;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModules = _$RegisterModules();
    gh.lazySingleton<_i361.Dio>(() => registerModules.createDio());
    gh.lazySingleton<_i383.HttpServices>(
      () => _i383.HttpServices(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i461.MovieDataSource>(
      () => _i461.MovieDataSource(gh<_i383.HttpServices>()),
    );
    gh.lazySingleton<_i1056.MovieRepositories>(
      () => _i1056.MovieRepositories(gh<_i461.MovieDataSource>()),
    );
    gh.factory<_i750.MovieListBloc>(
      () => _i750.MovieListBloc(gh<_i1056.MovieRepositories>()),
    );
    return this;
  }
}

class _$RegisterModules extends _i259.RegisterModules {}
