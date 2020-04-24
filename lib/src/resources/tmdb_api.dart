import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import '../models/response.dart';
import '../models/trailer.dart';

/*
This is we the request to The Movie DB is done

Movies DB API Key : 28fe1345095e5381abd32b0578210b0d

request link : https://api.themoviedb.org/3/movie/popular?api_key=28fe1345095e5381abd32b0578210b0d
*/
class TmdbApi {
  // This should be injected
  Client _client = Client();

  // basics components of the api request
  String baseUrl = 'api.themoviedb.org';
  String path = '3/discover/movie';
  String apiKey = '28fe1345095e5381abd32b0578210b0d';

  static final coverImagePath = 'https://image.tmdb.org/t/p/w500';
  static final movieImagePath = 'https://image.tmdb.org/t/p/w185';

  Future<ResponseModel> fetchMoviesResponse(
      {String language: 'en-US', String pageIndex}) async {
    // request url and the query parameters
    var uri = Uri.https(
      baseUrl,
      path,
      <String, String>{
        'api_key': apiKey,
        'language': language,
        'include_adult': 'false',
        'page': '$pageIndex',
      },
    );

    var response = await _client.get(uri);

    // addtional delay for slow connections
    await Future.delayed(
      Duration(seconds: 1),
    );

    if (response.statusCode == 200) {
      return ResponseModel.fromJson(jsonDecode(response.body));
    } else
      throw Exception('Failed to load results');
  }

// a function to fetch movie trailers given movie id
  Future<TrailerModel> fetchTrailersResponse(String movieId) async {
    String movieTrailerUrl =
        'https://$baseUrl/3/movie/$movieId/videos?api_key=$apiKey';

    var response = await _client.get(movieTrailerUrl);

    if (response.statusCode == 200) {
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}
