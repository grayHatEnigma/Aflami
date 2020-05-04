import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'bloc_base.dart';
import '../models/response.dart';
import '../resources/repository.dart';

class ResponseBloc extends BlocBase {
  // Base State
  // inital page index and movie genre
  int _pageIndex = 1;
  int _genre = 0;

  // This getter is to allow the filters screen a - direct - access
  // to the current selected  genre. id
  // I know this is a violation to the main BLoC principle
  // ( only depends on streams in exposing and manuplating data )
  // but it will save a lot of unesseccary complexity and boilerplate
  int get currentGenreId => _genre;
  // So Sorry BLoC :/ :( !

  // Thsi should be injected
  final _repository = Repository();

  static final instance = ResponseBloc._();
  factory ResponseBloc() => instance;
  ResponseBloc._() {
    // fetch initial data on Bloc creation
    _fetchResult(_pageIndex, _genre);

    // listen to events from index buttons in the home screen
    _pageIndexController.stream.listen(_mapResposneEventToState);

    // listen to  genre changes from filters screen
    _movieGenreController.stream.listen(_handleGenreChange);
  }

  // Controllers
  final _moviesController = PublishSubject<ResponseModel>();
  final _pageIndexController = PublishSubject<ResponseEvent>();
  final _movieGenreController = PublishSubject<int>();
  final _indexController = BehaviorSubject<int>();

  // streams
  Stream<ResponseModel> get allMovies => _moviesController.stream;
  Stream<int> get currentIndex => _indexController.stream;
  Stream<int> get moviesGenre => _movieGenreController.stream;

  // sinks
  Function(ResponseEvent) get dispatch => _pageIndexController.sink.add;
  Function(int) get chooseGenre => _movieGenreController.sink.add;

  // a function that make the network request to retrive list of movies with given page index
  Future _fetchResult(int pageIndex, int genre) async {
    try {
      final response = await _repository.fetchMoviesResponse(pageIndex, genre);
      _moviesController.sink.add(response);
    } catch (e) {
      _moviesController.sink.addError(e);
    }
  }

  // ############ Handling ################

  // handle genre changes
  void _handleGenreChange(newGenre) {
    // reset page index at each new genre
    _pageIndex = 1;
    // set the genre
    _genre = newGenre;

    // make the api call for the new genre and notify all interested widgets
    _loadAndNotify();
  }

  // a function the map the incoming index events from the ui to index state
  void _mapResposneEventToState(ResponseEvent event) async {
    if (event == ResponseEvent.next && _pageIndex <= 500) {
      _pageIndex++;
    } else if (event == ResponseEvent.previous && _pageIndex > 1) {
      _pageIndex--;
    } else if (event == ResponseEvent.home) {
      _pageIndex = 1;
    }
    _loadAndNotify();
  }

// ############# routines ###############
  void _loadAndNotify() async {
    // update the page index in home screen
    _indexController.add(_pageIndex);
    // to show a loading bar while we fetch the next page
    _loading();
    // fetch the movie page
    await _fetchResult(_pageIndex, _genre);
  }

  void _loading() => _moviesController.sink.add(null);

  // ################## disposing ###############
  @override
  void dispose() {
    print('Response Bloc is dispose');
    _moviesController.close();
    _pageIndexController.close();
    _indexController.close();
    _movieGenreController.close();
  }
}

enum ResponseEvent { next, previous, home, retry }
