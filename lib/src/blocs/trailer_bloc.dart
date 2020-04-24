import 'bloc_base.dart';

import '../models/trailer.dart';
import '../resources/repository.dart';

import 'dart:async';

class TrailerBloc extends BlocBase {
  // repository
  final _repository = Repository();

  // Controllers
  final _movieIdController = StreamController<int>();
  final _trailerController = StreamController<TrailerModel>();

  // streams
  Stream<TrailerModel> get trailers => _trailerController.stream;

  // sinks
  Function(int) get findTrailers => _movieIdController.sink.add;

  // Constructor
  TrailerBloc() {
    _movieIdController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(event) async {
    final trailerModel = await _repository.fetchTrailersResponse(event);
    _trailerController.sink.add(trailerModel);
  }

  @override
  void dispose() {
    print('TrailerBloc is disposed');
    _movieIdController.close();
    _trailerController.close();
  }
}
