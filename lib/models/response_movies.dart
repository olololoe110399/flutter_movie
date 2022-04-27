import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_movie/models/movie.dart';

part 'response_movies.g.dart';

@JsonSerializable()
class ResponseMovies {
  @JsonKey(name: 'page')
  int? page;
  @JsonKey(name: 'total_results')
  int? totalResults;
  @JsonKey(name: 'total_pages')
  int? totalPages;
  @JsonKey(name: 'results')
  List<Movie>? results;
  ResponseMovies({
    this.page,
    this.totalResults,
    this.totalPages,
    this.results,
  });

  factory ResponseMovies.fromJson(Map<String, dynamic> json) =>
      _$ResponseMoviesFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseMoviesToJson(this);

  @override
  String toString() {
    return 'ResponseMovies(page: $page, totalResults: $totalResults, totalPages: $totalPages, results: $results)';
  }
}
