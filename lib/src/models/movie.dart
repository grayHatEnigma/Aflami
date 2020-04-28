class Movie {
  String _id;
  num _voteAverage;
  String _title;
  String _posterPath;
  String _overview;
  String _releaseDate;

  Movie(result) {
    _id = result['id'].toString();
    _voteAverage = result['vote_average'];
    _title = result['title'];
    _posterPath = result['poster_path'];
    _overview = result['overview'];
    _releaseDate = result['release_date'];
  }

  String get releaseDate => _releaseDate;

  String get overview => _overview;

  String get posterPath => _posterPath;

  String get title => _title;

  num get voteAverage => _voteAverage;

  String get id => _id;
}
