import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import '../models/genres.dart';

import 'bloc_base.dart';

class GenresBloc extends BlocBase {
  Repository _repository = Repository();

  // controller to fetch all genres list for filters screen
  // it will expose a stream only
  final _genresController = BehaviorSubject<Genres>();
  Stream<Genres> get genres => _genresController.stream;

  final _genresEventController = PublishSubject<GenresEvent>();
  Function(GenresEvent) get dispatch => _genresEventController.sink.add;

// constructor
  GenresBloc() {
    _genresEventController.stream.listen(_handleGenresEvent);

    // fetch genres list on app start
    _fetchGenresList();
  }

  void _fetchGenresList() {
    _repository
        .fetchGenres()
        .then((value) => _genresController.sink.add(value))
        .catchError((error) {
      _genresController.sink.addError(error);
    });
  }

// ############## Handling ##################

  void _handleGenresEvent(event) {
    if (event == GenresEvent.retry) {
      _fetchGenresList();
    }
  }

  @override
  void dispose() {
    print('GenresBloc is disposed');
    _genresController.close();
    _genresEventController.close();
  }
}

enum GenresEvent { retry }
