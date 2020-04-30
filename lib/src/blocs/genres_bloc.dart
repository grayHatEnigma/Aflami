import 'dart:async';

import '../resources/repository.dart';
import '../models/genres.dart';

import 'bloc_base.dart';

class GenresBloc extends BlocBase {
  Repository _repository = Repository();

  // controller to fetch all genres list for filters screen
  // it will expose a stream only
  final _genresController = StreamController<Genres>();
  Stream<Genres> get genres => _genresController.stream;

// constructor
  GenresBloc() {
    _repository
        .fetchGenres()
        .then((value) => _genresController.sink.add(value));
  }

  @override
  void dispose() {
    print('GenresBloc is disposed');
    _genresController.close();
  }
}
