import 'genre.dart';

class Genres {
  List<Genre> _genres;

  Genres.initialState() {
    _genres = []..insert(
        0,
        Genre(0, 'All'),
      );
  }

  Genres.fromJson(Map<String, dynamic> parsedJson)
      : _genres = (parsedJson["genres"] as List<dynamic>)
            .map((item) => Genre.fromJson(item))
            .toList()
              ..insert(
                0,
                Genre(0, 'All'),
              );

  //
  // Return the genre name by its id
  //
  String findById(int genreId) =>
      genres.firstWhere((g) => g.id == genreId).name;

  List<Genre> get genres => _genres;
}
