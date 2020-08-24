import 'tmdb_api.dart';
import '../models/response.dart';
import '../models/genres.dart';
import '../models/trailer.dart';
import '../models/movie.dart';

/// This Repository class is the central point from where the data will flow to the BLoC.
/// and serves as an extra separation layer for the network call.

class Repository {
  // This should be injected
  TmdbApi _tmdbApiProvider;
  // Singleton Pattern to insure there is only one repo in the app
  static final instance = Repository._();
  factory Repository() => instance;
  Repository._() {
    _tmdbApiProvider = TmdbApi();
  }

// fetch genres list
  Future<Genres> fetchGenres() => _tmdbApiProvider.fetchGenres();

// fetch movies list from the api
  Future<ResponseModel> fetchMoviesResponse(int pageIndex, int genre) =>
      _tmdbApiProvider.fetchMoviesResponse(
          pageIndex: pageIndex.toString(), genre: genre);

// fetch trailers list from the api
  Future<TrailerModel> fetchTrailersResponse(String movieId) =>
      _tmdbApiProvider.fetchTrailersResponse(movieId);

// fetch movie detail for favorites screen
  Future<Movie> fetchMovie(String movieId) =>
      _tmdbApiProvider.fetchMovie(movieId);
}
