// To parse this JSON data, do
//
//     final popularMoviesResponse = popularMoviesResponseFromJson(jsonString);

import 'dart:convert';

import '../models.dart';

class PopularMoviesResponse {
  PopularMoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory PopularMoviesResponse.fromRawJson(String str) =>
      PopularMoviesResponse.fromJson(json.decode(str));

  factory PopularMoviesResponse.fromJson(Map<String, dynamic> json) =>
      PopularMoviesResponse(
        page: json["page"],
        results:
            List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
