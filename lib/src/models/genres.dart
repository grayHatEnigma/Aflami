import 'genre.dart';

class Genres {
  List<Genre> _genres;

  Genres.initialState() {
    _genres = []..add(Genre(0, 'All Categories'));
  }

  Genres.fromJson(Map<String, dynamic> parsedJson)
      : _genres = (parsedJson["genres"] as List<dynamic>)
            .map((item) => Genre.fromJson(item))
            .toList()
              ..add(Genre(0, 'All Categories'));

  //
  // Return the genre name by its id
  //
  String findById(int genreId) =>
      genres.firstWhere((g) => g.id == genreId).name;

  List<Genre> get genres => _genres;
}
