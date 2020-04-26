import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';

import 'bloc_base.dart';

class FavoritesBloc extends BlocBase {
  // State
  // will be  a set of integers (movies indexes)
  // set of unique movies ids
  Set<int> _favorites = {};
  int get _totalFavorites => _favorites.length;

  // Controllers
  // we need 4 controllers

  // 1- controller for getting total favorites count
  final _totalFavoritesContrller = BehaviorSubject<int>();
  Stream<int> get outTotalFavorites => _totalFavoritesContrller.stream;
  StreamSink<int> get _inTotalFavorites => _totalFavoritesContrller.sink;

  // 2- controller for getting the favorites list
  final _favoritesController =
      BehaviorSubject<List<int>>(); // multiple listners
  Stream<List<int>> get outFavorites => _favoritesController.stream;
  StreamSink<List<int>> get _inFavorites => _favoritesController.sink;

  // 3- controller for add / remove favorite movie

  /// Interface that allows to add a new favorite movie
  StreamController<int> _favoriteAddController = StreamController<int>();
  Function(int) get inAddFavorite => _favoriteAddController.sink.add;

  /// Interface that allows to remove a movie from the list of favorites
  StreamController<int> _favoriteRemoveController = StreamController<int>();
  Function(int) get inRemoveFavorite => _favoriteRemoveController.sink.add;

  // 4- controller that determines wether a given movie is in favorites or not
  StreamController<bool> _isFavoriteController = StreamController.broadcast();
  Stream<bool> get isFavorite => _isFavoriteController.stream;

  StreamController<int> _checkMovieController = StreamController.broadcast();
  Function(int) get checkMovie => _checkMovieController.sink.add;

  // constructor
  FavoritesBloc() {
    _favoriteAddController.stream.listen(_handleAddFavorite);
    _favoriteRemoveController.stream.listen(_handleRemoveFavorite);
    _checkMovieController.stream.listen(_handleMovieCheck);
  }

// ############# Handling Logic #################
  void _handleMovieCheck(movieId) {
    _isFavoriteController.sink.add(_favorites.any((item) => item == movieId));
  }

  void _handleAddFavorite(movieId) {
    // add the movie id to the list
    _favorites.add(movieId);

    //
    _notify();
  }

  void _handleRemoveFavorite(movieId) {
    // remove the movie id from the list
    _favorites.remove(movieId);

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
}
