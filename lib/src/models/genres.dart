import 'genre.dart';

class Genres {
  List<Genre> _genres;

  Genres.initialState() {
    _genres = [];
  }

  Genres.fromJson(Map<String, dynamic> parsedJson)
      : _genres = (parsedJson["genres"] as List<dynamic>)
            .map((item) => Genre.fromJson(item))
            .toList();

  List<Genre> get genres => _genres;
}
