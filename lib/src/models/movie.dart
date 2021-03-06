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

  Movie.fromString(String encoded) {
    final encodedProps = encoded.split('%!%').toList();
    _id = encodedProps[0];
    _voteAverage = num.parse(encodedProps[1]);
    _title = encodedProps[2];
    // this line is important cause it didn't consider 'null' as String a null Object.
    _posterPath = encodedProps[3] == 'null' ? null : encodedProps[3];
    _overview = encodedProps[4];
    _releaseDate = encodedProps[5];
  }

  @override
  String toString() =>
      '$_id%!%$_voteAverage%!%$_title%!%$_posterPath%!%$_overview%!%$_releaseDate';

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) || this._id == other._id;

  @override
  int get hashCode => int.parse(_id);

  String get releaseDate => _releaseDate;

  String get overview => _overview;

  String get posterPath => _posterPath;

  String get title => _title;

  num get voteAverage => _voteAverage;

  String get id => _id;
}
