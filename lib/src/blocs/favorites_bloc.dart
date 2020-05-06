import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc_base.dart';
import '../models/movie.dart';

class FavoritesBloc extends BlocBase {
  // State
  //  a set of movies
  Set<Movie> _favorites = {};

  int get _totalFavorites => _favorites.length;

  /// Controllers
  /// we need 5 types of controllers

  /// 1- controller for getting total favorites count
  final _totalFavoritesContrller = BehaviorSubject<int>();
  Stream<int> get outTotalFavorites => _totalFavoritesContrller.stream;
  StreamSink<int> get _inTotalFavorites => _totalFavoritesContrller.sink;

  /// 2- controller for getting the favorites list
  final _favoritesController =
      BehaviorSubject<List<Movie>>(); // multiple listners
  Stream<List<Movie>> get outFavorites => _favoritesController.stream;
  StreamSink<List<Movie>> get _inFavorites => _favoritesController.sink;

  /// 3- controller for add / remove favorite movie

  // Interface that allows to add a new favorite movie
  StreamController<Movie> _favoriteAddController = StreamController<Movie>();
  Function(Movie) get inAddFavorite => _favoriteAddController.sink.add;

  // Interface that allows to remove a movie from the list of favorites
  StreamController<Movie> _favoriteRemoveController = StreamController<Movie>();
  Function(Movie) get inRemoveFavorite => _favoriteRemoveController.sink.add;

  /// 4- controller that determines wether a given movie is in favorites or not
  StreamController<bool> _isFavoriteController = StreamController.broadcast();
  Stream<bool> get isFavorite => _isFavoriteController.stream;

  StreamController<String> _checkMovieController = StreamController.broadcast();
  Function(String) get checkMovie => _checkMovieController.sink.add;

  // ########### Constructor ##############
  FavoritesBloc() {
    _favoriteAddController.stream.listen(_handleAddFavorite);
    _favoriteRemoveController.stream.listen(_handleRemoveFavorite);
    _checkMovieController.stream.listen(_handleMovieCheck);

    _readFromSharedPreferences().then((movies) async {
      _favorites = movies;
      print('Favorites fetching done!');
      // notify all the listning widgets
      _notify();
    });
  }

// ############# Handling Logic #################
  void _handleMovieCheck(movieId) {
    _isFavoriteController.sink
        .add(_favorites.any((item) => item.id == movieId));
  }

  void _handleAddFavorite(movie) {
    // add the movie id to the list
    _favorites.add(movie);
    _saveToSharedPreferences(_favorites);

    //
    _notify();
  }

  void _handleRemoveFavorite(movie) {
    // remove the movie id from the list
    _favorites.removeWhere((item) => item.id == movie.id);

    _saveToSharedPreferences(_favorites);

    //
    _notify();
  }

  void _notify() {
    _inTotalFavorites.add(_totalFavorites);
    _inFavorites.add(UnmodifiableListView(_favorites));
  }

  @override
  void dispose() {
    print('FavoritesBloc is disposed');
    _favoriteAddController.close();
    _favoriteRemoveController.close();
    _totalFavoritesContrller.close();
    _favoritesController.close();
    _isFavoriteController.close();
    _checkMovieController.close();
  }

  // ######## Shared Prefrences #########
  Future<SharedPreferences> get _sharedPreferences async =>
      await SharedPreferences.getInstance();

  Future<Set<Movie>> _readFromSharedPreferences() async {
    final shared = await _sharedPreferences;
    final list = shared.getStringList('movies');
    if (list != null) {
      return list
          .map(
            (encoded) => Movie.fromString(encoded),
          )
          .toSet();
    }
    return {};
  }

  void _saveToSharedPreferences(Set<Movie> favorites) async {
    final shared = await _sharedPreferences;
    shared.setStringList(
      'movies',
      favorites
          .map(
            (movie) => movie.toString(),
          )
          .toList(),
    );
  }
} //class
