import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'bloc_base.dart';
import '../models/movie.dart';
import '../resources/repository.dart';

class MovieDetailBloc extends BlocBase {
  Repository _repository = Repository();

// we need 2 controllers

// 1- a controller to get the movie ID list from the UI  =>
// it will expose a sink of List<int>
  final _movieIdListController = PublishSubject<List<int>>();
  Function(List<int>) get fetchMovies => _movieIdListController.sink.add;

// 2- a controller to get the fetched list of movie objects
  final _movieListController = PublishSubject<List<Movie>>();
  Stream<List<Movie>> get movies => _movieListController.stream;

// ######### Constructor ###########
  MovieDetailBloc() {
    _movieIdListController.listen(_handleMovieList);
  }

// ####### Handling Logic ##########

  void _handleMovieList(List<int> ids) async {
    // FIXME: adding events after disposing
    List<Movie> movies = [];
    for (int id in ids) {
      final movie = await _fetchMovieDetail(id);
      movies.add(movie);
    }

    _movieListController.sink.add(movies);
  }

  Future<Movie> _fetchMovieDetail(int movieId) {
    return _repository.fetchMovieDetail(movieId);
  }

// ######### Disposing #########
  @override
  void dispose() async {
    print('MovieDetailBloc is disposed');
    _movieIdListController.close();
    _movieListController.close();
  }
}
