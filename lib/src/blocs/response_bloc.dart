import 'dart:async';

import 'bloc_base.dart';
import '../models/response.dart';
import '../resources/repository.dart';

class ResponseBloc extends BlocBase {
  // Thsi should be injected
  final _repository = Repository();

  static final instance = ResponseBloc._();
  factory ResponseBloc() => instance;
  ResponseBloc._() {
    // fetch initial data on Bloc creation
    _fetchResult(_pageIndex);

    // listen to events from index buttons in the ui
    _pageIndexController.stream.listen(_mapEventToState);
  }

  // State
  // page index state
  int _pageIndex = 1;

  // Controllers
  final _moviesController = StreamController<ResponseModel>();
  final _pageIndexController = StreamController<ResponseEvent>();
  final _indexController = StreamController<int>();

  // streams
  Stream<ResponseModel> get allMovies => _moviesController.stream;
  Stream<int> get currentIndex => _indexController.stream;

  // sinks
  Function(ResponseEvent) get dispath => _pageIndexController.sink.add;

  // a function that make the network request to retrive list of movies with given page index
  Future _fetchResult(_pageIndex) async {
    final response = await _repository.fetchMoviesResponse(_pageIndex);
    _moviesController.sink.add(response);
  }

  // a function the map the incoming index events from the ui to index state
  void _mapEventToState(ResponseEvent event) async {
    if (event == ResponseEvent.next && _pageIndex <= 500) {
      _pageIndex++;
      _indexController.add(_pageIndex);
      // to show loading bar while we fetch the next page
      _loading();
      await _fetchResult(_pageIndex);
    } else if (event == ResponseEvent.previous && _pageIndex > 1) {
      _pageIndex--;
      _indexController.add(_pageIndex);
      // to show loading bar while we fetch the next page
      _loading();
      await _fetchResult(_pageIndex);
    }
  }

  void _loading() => _moviesController.sink.add(null);
  // Dispose and close all Controllers
  @override
  void dispose() {
    print('Response Bloc is dispose');
    _moviesController.close();
    _pageIndexController.close();
    _indexController.close();
  }
}

enum ResponseEvent { next, previous }
