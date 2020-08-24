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

  // This getter is to allow the filters / navigation screens a - direct - access
  // to the current selected  genre. id / index
  // I know this is a violation to the main BLoC principle
  // ( only depends on streams in exposing and manuplating data )
  // but it will save a lot of unesseccary complexity and boilerplate
  int get currentGenreId => _genre;
  int get currentPageIndex => _pageIndex;
  // So Sorry BLoC :/ :( !

  // Thsi should be injected
  final _repository = Repository();

  static final instance = ResponseBloc._();
  factory ResponseBloc() => instance;
  ResponseBloc._() {
    // fetch initial data on Bloc creation
    _fetchResult(_pageIndex, _genre);

    // listen to events from index buttons in the home screen
    _eventController.stream.listen(_mapResposneEventToState);

    // listen to  genre changes from filters screen
    _genreInjectorController.stream.listen(_handleGenreChange);

    // listen to  page index changes from navigator screen
    _pageInjectorController.stream.listen(_handleIndexChange);
  }

  // Controllers
  // events related ( actions )
  final _eventController = PublishSubject<ResponseEvent>();
  final _genreInjectorController = PublishSubject<int>();
  final _pageInjectorController = PublishSubject<int>();

  // data related (show or expose data to the UI)
  final _moviesController = PublishSubject<ResponseModel>();
  final _indexController = BehaviorSubject<int>();
  final _genreIdController = BehaviorSubject<int>();

  // streams
  Stream<ResponseModel> get allMovies => _moviesController.stream;
  Stream<int> get currentIndex => _indexController.stream;
  Stream<int> get genreId => _genreIdController.stream;

  // sinks
  Function(ResponseEvent) get dispatch => _eventController.sink.add;
  Function(int) get chooseGenre => _genreInjectorController.sink.add;
  Function(int) get navigateTo => _pageInjectorController.sink.add;

  // a function that make the main network request to retrive list of movies with given page index
  Future _fetchResult(int pageIndex, int genre) async {
    try {
      final response = await _repository.fetchMoviesResponse(pageIndex, genre);
      _moviesController.sink.add(response);
    } catch (e) {
      _moviesController.sink.addError(e);
    }
  }

  // ######################## Handling ################################

  void _handleIndexChange(newIndex) {
    // update the pgae index
    _pageIndex = newIndex;

    // make the api call for the new page index and notify all interested widgets
    _loadAndNotify();
  }

  // handle genre changes
  void _handleGenreChange(newGenre) {
    // reset page index at each new genre
    _pageIndex = 1; // this is optional but I prefer it.

    // update the genre.
    _genre = newGenre;

    // make the api call for the new genre and notify all interested widgets
    _loadAndNotify();
  }

  // a function the map the incoming response events from the ui to state ( index )
  void _mapResposneEventToState(ResponseEvent event) async {
    if (event == ResponseEvent.next && _pageIndex < 500) {
      _pageIndex++;
    } else if (event == ResponseEvent.previous && _pageIndex > 1) {
      _pageIndex--;
    } else if (event == ResponseEvent.home) {
      _pageIndex = 1;
    } else if (event == ResponseEvent.retry) {
    } else {
      return;
    }
    // a routine to add into the sinks
    _loadAndNotify();
  }

// ######################### routines ###########################
  void _loadAndNotify() async {
    // update the page index in home screen and whoever is listening
    _indexController.add(_pageIndex);

    // update the genre id in home screen and whoever is listening
    _genreIdController.add(_genre);

    // to show a loading bar while we fetch the next page
    _loading();

    // fetch the movie page
    await _fetchResult(_pageIndex, _genre);
  }

  // this function sole purpose is to show a loading bar while we fetch the next page
  // by adding 'null' into the movies controller until the next page fetching is completed
  void _loading() => _moviesController.sink.add(null);

  // ########################## disposing ###############################
  @override
  void dispose() {
    print('Response Bloc is dispose');
    _moviesController.close();
    _eventController.close();
    _indexController.close();
    _genreIdController.close();
    _genreInjectorController.close();
    _pageInjectorController.close();
  }
}

// I prefer this ( Enums ) for Events over using Objects and classes.
enum ResponseEvent { next, previous, home, retry }
