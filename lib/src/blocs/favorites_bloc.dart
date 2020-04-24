import 'dart:async';
import 'bloc_base.dart';

// TODO : implement favorites bloc  class
class FavoritesBloc extends BlocBase {
  // State
  // will be  a set of integers (movies indexes)
  // set of unique movies ids
  Set<int> _favoritesList = {};
  int get _favoritesCount => _favoritesList.length;

  // Controllers
  // we need 3 controllers
  // 1- controller for getting favorites count
  // 2- controller for getting the favorites list
  // 3- controller for add / remove favorite movie

  // each controller has its owm handle logic function.

  @override
  void dispose() {}
}

enum FavoritesEvent { add, remove }
