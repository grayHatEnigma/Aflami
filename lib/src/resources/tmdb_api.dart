import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'exceptions.dart';
import '../models/response.dart';
import '../models/trailer.dart';
import '../models/movie.dart';
import '../models/genres.dart';

/*
This is where the requests to The Movie DB is done
Movies DB API Key : 28fe1345095e5381abd32b0578210b0d
*/

class TmdbApi {
  // basics components of the api request
  String baseUrl = 'api.themoviedb.org';
  String path = '3/discover/movie';
  String apiKey = '28fe1345095e5381abd32b0578210b0d';
  String genresPath = '/3/genre/movie/list';

  static final coverImagePath = 'https://image.tmdb.org/t/p/w500';

/*  

Improved Api Calls 

*/

  // a function to fetch genres list
  Future<Genres> fetchGenres() async {
    String genresUrl = 'https://$baseUrl$genresPath?api_key=$apiKey';
    final parsedJson = await _getParsedJson(genresUrl);
    return Genres.fromJson(parsedJson);
  }

  //  a function to fectch movie detail for favorites screen
  Future<Movie> fetchMovie(String movieId) async {
    String movieDetailUrl = 'https://$baseUrl/3/movie/$movieId?api_key=$apiKey';
    final parsedJson = await _getParsedJson(movieDetailUrl);
    return Movie(parsedJson);
  }

// a function to fetch movie trailers given movie id
  Future<TrailerModel> fetchTrailersResponse(String movieId) async {
    String movieTrailerUrl =
        'https://$baseUrl/3/movie/$movieId/videos?api_key=$apiKey';
    final parsedJson = await _getParsedJson(movieTrailerUrl);
    return TrailerModel.fromJson(parsedJson);
  }

  // a function to fetch movies list for home screen
  Future<ResponseModel> fetchMoviesResponse(
      {String language: 'en-US', String pageIndex, int genre}) async {
    // request url and the query parameters
    var uri = Uri.https(
      baseUrl,
      path,
      <String, String>{
        'api_key': apiKey,
        'language': language,
        'include_adult': 'false',
        'page': '$pageIndex',
        'with_genres': '$genre',
      },
    );
    final parsedJson = await _getParsedJson(uri);
    // addtional delay for slow connections
    await Future.delayed(
      Duration(seconds: 1),
    );
    return ResponseModel.fromJson(parsedJson);
  }

// ############# routines to send api requests and handle exceptions  ############

  Future _getParsedJson(url) async {
    var parsedJson;
    try {
      var response = await http.get(url);
      parsedJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return parsedJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body);
      case 401:

      case 403:
        throw UnauthorisedException(response.body);
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
} // class
