import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fl_movies_app/helpers/helpers.dart';
import 'package:fl_movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '9f81c2c5de878399a3cd3816a249a16a';
  final String _language = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData({required String endpoint, int page = 1}) async {
    Uri url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);

    return response.body;
  }

  void getNowPlayingMovies() async {
    try {
      final response = await _getJsonData(endpoint: '3/movie/now_playing');

      final jsonResponse = NowPlayingResponse.fromRawJson(response);

      onDisplayMovies = jsonResponse.results;

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void getPopularMovies() async {
    try {
      _popularPage++;

      final response =
          await _getJsonData(endpoint: '3/movie/popular', page: _popularPage);

      final jsonResponse = PopularMoviesResponse.fromRawJson(response);

      popularMovies = [...popularMovies, ...jsonResponse.results];

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    try {
      if (moviesCast[movieId] != null) {
        return moviesCast[movieId]!;
      }

      final response = await _getJsonData(endpoint: '3/movie/$movieId/credits');

      final jsonResponse = CreditsResponse.fromRawJson(response);

      moviesCast[movieId] = jsonResponse.cast;

      return jsonResponse.cast;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      Uri url = Uri.https(_baseUrl, '3/search/movie', {
        'api_key': _apiKey,
        'language': _language,
        'page': '1',
        'query': query
      });

      final response = await http.get(url);

      final jsonResponse = MovieSearchResponse.fromRawJson(response.body);

      return jsonResponse.results;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';

    debouncer.onValue = (value) async {
      final results = await searchMovies(value);

      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
