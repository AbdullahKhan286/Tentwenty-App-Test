import 'package:flutter/foundation.dart';

// Movie Detail Model
@immutable
class MovieDetail {
  final bool adult;
  final String? backdropPath;
  final int budget;
  final List<Genre> genres;
  final String? homepage;
  final int id;
  final String? imdbId;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final String releaseDate;
  final int revenue;
  final int runtime;
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String? tagline;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  const MovieDetail({
    required this.adult,
    this.backdropPath,
    required this.budget,
    required this.genres,
    this.homepage,
    required this.id,
    this.imdbId,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      adult: json['adult'] as bool,
      backdropPath: json['backdrop_path'] as String?,
      budget: json['budget'] as int,
      genres: (json['genres'] as List<dynamic>)
          .map((genreJson) => Genre.fromJson(genreJson as Map<String, dynamic>))
          .toList(),
      homepage: json['homepage'] as String?,
      id: json['id'] as int,
      imdbId: json['imdb_id'] as String?,
      originCountry: (json['origin_country'] as List<dynamic>)
          .map((country) => country as String)
          .toList(),
      originalLanguage: json['original_language'] as String,
      originalTitle: json['original_title'] as String,
      overview: json['overview'] as String,
      popularity: (json['popularity'] as num).toDouble(),
      posterPath: json['poster_path'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>)
          .map((companyJson) =>
              ProductionCompany.fromJson(companyJson as Map<String, dynamic>))
          .toList(),
      productionCountries: (json['production_countries'] as List<dynamic>)
          .map((countryJson) =>
              ProductionCountry.fromJson(countryJson as Map<String, dynamic>))
          .toList(),
      releaseDate: json['release_date'] as String,
      revenue: json['revenue'] as int,
      runtime: json['runtime'] as int,
      spokenLanguages: (json['spoken_languages'] as List<dynamic>)
          .map((langJson) =>
              SpokenLanguage.fromJson(langJson as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      tagline: json['tagline'] as String?,
      title: json['title'] as String,
      video: json['video'] as bool,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
    );
  }

  String get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w780$backdropPath'
      : '';

  String get formattedRuntime {
    if (runtime <= 0) return 'Unknown';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get formattedReleaseDate {
    try {
      final date = DateTime.parse(releaseDate);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return releaseDate;
    }
  }
}

@immutable
class Genre {
  final int id;
  final String name;

  const Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

@immutable
class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  const ProductionCompany({
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'] as int,
      logoPath: json['logo_path'] as String?,
      name: json['name'] as String,
      originCountry: json['origin_country'] as String,
    );
  }
}

@immutable
class ProductionCountry {
  final String iso31661;
  final String name;

  const ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso31661: json['iso_3166_1'] as String,
      name: json['name'] as String,
    );
  }
}

@immutable
class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  const SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'] as String,
      iso6391: json['iso_639_1'] as String,
      name: json['name'] as String,
    );
  }
}

// Movie Videos Model
@immutable
class MovieVideosResponse {
  final int id;
  final List<MovieVideo> results;

  const MovieVideosResponse({
    required this.id,
    required this.results,
  });

  factory MovieVideosResponse.fromJson(Map<String, dynamic> json) {
    return MovieVideosResponse(
      id: json['id'] as int,
      results: (json['results'] as List<dynamic>)
          .map((videoJson) =>
              MovieVideo.fromJson(videoJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

@immutable
class MovieVideo {
  final String iso6391;
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  const MovieVideo({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory MovieVideo.fromJson(Map<String, dynamic> json) {
    return MovieVideo(
      iso6391: json['iso_639_1'] as String,
      iso31661: json['iso_3166_1'] as String,
      name: json['name'] as String,
      key: json['key'] as String,
      site: json['site'] as String,
      size: json['size'] as int,
      type: json['type'] as String,
      official: json['official'] as bool,
      publishedAt: json['published_at'] as String,
      id: json['id'] as String,
    );
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
  String get youtubeThumbnail =>
      'https://img.youtube.com/vi/$key/maxresdefault.jpg';
}

// Movie Images Model
@immutable
class MovieImagesResponse {
  final List<MovieImage> backdrops;
  final int id;
  final List<MovieImage> logos;
  final List<MovieImage> posters;

  const MovieImagesResponse({
    required this.backdrops,
    required this.id,
    required this.logos,
    required this.posters,
  });

  factory MovieImagesResponse.fromJson(Map<String, dynamic> json) {
    return MovieImagesResponse(
      backdrops: (json['backdrops'] as List<dynamic>)
          .map((imageJson) =>
              MovieImage.fromJson(imageJson as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int,
      logos: (json['logos'] as List<dynamic>)
          .map((imageJson) =>
              MovieImage.fromJson(imageJson as Map<String, dynamic>))
          .toList(),
      posters: (json['posters'] as List<dynamic>)
          .map((imageJson) =>
              MovieImage.fromJson(imageJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

@immutable
class MovieImage {
  final double aspectRatio;
  final int height;
  final String? iso6391;
  final String filePath;
  final double voteAverage;
  final int voteCount;
  final int width;

  const MovieImage({
    required this.aspectRatio,
    required this.height,
    this.iso6391,
    required this.filePath,
    required this.voteAverage,
    required this.voteCount,
    required this.width,
  });

  factory MovieImage.fromJson(Map<String, dynamic> json) {
    return MovieImage(
      aspectRatio: (json['aspect_ratio'] as num).toDouble(),
      height: json['height'] as int,
      iso6391: json['iso_639_1'] as String?,
      filePath: json['file_path'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
      width: json['width'] as int,
    );
  }

  String get fullImageUrl => 'https://image.tmdb.org/t/p/original$filePath';
  String get mediumImageUrl => 'https://image.tmdb.org/t/p/w500$filePath';
}
