// To parse this JSON data, do
//
//     final movieSearchResponse = movieSearchResponseFromJson(jsonString);

import 'dart:convert';

import '../models.dart';

class MovieSearchResponse {
  MovieSearchResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory MovieSearchResponse.fromRawJson(String str) =>
      MovieSearchResponse.fromJson(json.decode(str));

  factory MovieSearchResponse.fromJson(Map<String, dynamic> json) =>
      MovieSearchResponse(
        page: json["page"],
        results:
            List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
