import 'movie.dart';

class ResponseModel {
  int _page;
  int _totalResults;
  int _totalPages;
  List<Movie> _results = [];

  ResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    _page = parsedJson['page'];
    _totalResults = parsedJson['total_results'];
    _totalPages = parsedJson['total_pages'];
    List<Movie> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      Movie result = Movie(parsedJson['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Movie> get results => _results;

  int get totalPages => _totalPages;

  int get totalResults => _totalResults;

  int get page => _page;
}
