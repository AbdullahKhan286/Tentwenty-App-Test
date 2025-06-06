import 'package:flutter/foundation.dart';

@immutable
class MovieResponse {
  final DateRange dates;
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  const MovieResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      dates: DateRange.fromJson(json['dates'] as Map<String, dynamic>),
      page: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((movieJson) => Movie.fromJson(movieJson as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );
  }

  MovieResponse copyWith({
    DateRange? dates,
    int? page,
    List<Movie>? results,
    int? totalPages,
    int? totalResults,
  }) {
    return MovieResponse(
      dates: dates ?? this.dates,
      page: page ?? this.page,
      results: results ?? this.results,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
    );
  }
}

@immutable
class DateRange {
  final String maximum;
  final String minimum;

  const DateRange({
    required this.maximum,
    required this.minimum,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      maximum: json['maximum'] as String,
      minimum: json['minimum'] as String,
    );
  }
}

@immutable
class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  const Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      genreIds:
          (json['genre_ids'] as List<dynamic>).map((id) => id as int).toList(),
      id: json['id'] as int,
      originalLanguage: json['original_language'] as String,
      originalTitle: json['original_title'] as String,
      overview: json['overview'] as String,
      popularity: (json['popularity'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String,
      title: json['title'] as String,
      video: json['video'] as bool,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );
  }
}
