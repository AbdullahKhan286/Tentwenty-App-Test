import 'package:get/get.dart';

import '../../model/movie_detail_model.dart';
import '../../service/api_service.dart';

class MovieDetailController extends GetxController {
  // Observable states
  Rxn<MovieDetail> movieDetail = Rxn<MovieDetail>();
  Rxn<MovieVideosResponse> movieVideos = Rxn<MovieVideosResponse>();
  Rxn<MovieImagesResponse> movieImages = Rxn<MovieImagesResponse>();

  RxBool isLoadingDetail = false.obs;
  RxBool isLoadingVideos = false.obs;
  RxBool isLoadingImages = false.obs;

  RxBool hasDetailError = false.obs;
  RxBool hasVideosError = false.obs;
  RxBool hasImagesError = false.obs;

  RxString detailErrorMessage = ''.obs;
  RxString videosErrorMessage = ''.obs;
  RxString imagesErrorMessage = ''.obs;

  // Current movie ID
  int? _currentMovieId;

  /// Load all movie data
  Future<void> loadMovieData(int movieId) async {
    _currentMovieId = movieId;

    // Load all data concurrently
    await Future.wait([
      getMovieDetail(movieId),
      getMovieVideos(movieId),
      getMovieImages(movieId),
    ]);
  }

  /// Get movie detail
  Future<void> getMovieDetail(int movieId) async {
    try {
      isLoadingDetail.value = true;
      hasDetailError.value = false;
      detailErrorMessage.value = '';

      final response = await ApiService.getMovieDetail(movieId);
      movieDetail.value = response;
    } catch (error) {
      hasDetailError.value = true;
      detailErrorMessage.value = error.toString();
      print('Error loading movie detail: $error');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  /// Get movie videos (trailers)
  Future<void> getMovieVideos(int movieId) async {
    try {
      isLoadingVideos.value = true;
      hasVideosError.value = false;
      videosErrorMessage.value = '';

      final response = await ApiService.instance.getMovieVideos(movieId);
      movieVideos.value = response;
    } catch (error) {
      hasVideosError.value = true;
      videosErrorMessage.value = error.toString();
      print('Error loading movie videos: $error');
    } finally {
      isLoadingVideos.value = false;
    }
  }

  /// Get movie images
  Future<void> getMovieImages(int movieId) async {
    try {
      isLoadingImages.value = true;
      hasImagesError.value = false;
      imagesErrorMessage.value = '';

      final response = await ApiService.instance.getMovieImages(movieId);
      movieImages.value = response;
    } catch (error) {
      hasImagesError.value = true;
      imagesErrorMessage.value = error.toString();
      print('Error loading movie images: $error');
    } finally {
      isLoadingImages.value = false;
    }
  }

  /// Refresh all data
  Future<void> refreshMovieData() async {
    if (_currentMovieId != null) {
      await loadMovieData(_currentMovieId!);
    }
  }

  /// Get the main trailer video
  MovieVideo? get mainTrailer {
    if (movieVideos.value == null) return null;

    final videos = movieVideos.value!.results;

    // Look for official trailer first
    var trailer = videos
        .where((video) =>
            video.type.toLowerCase() == 'trailer' &&
            video.official &&
            video.site.toLowerCase() == 'youtube')
        .firstOrNull;

    // If no official trailer, look for any trailer
    trailer ??= videos
        .where((video) =>
            video.type.toLowerCase() == 'trailer' &&
            video.site.toLowerCase() == 'youtube')
        .firstOrNull;

    // If no trailer, look for any teaser
    trailer ??= videos
        .where((video) =>
            video.type.toLowerCase() == 'teaser' &&
            video.site.toLowerCase() == 'youtube')
        .firstOrNull;

    return trailer;
  }

  /// Get all trailers
  List<MovieVideo> get allTrailers {
    if (movieVideos.value == null) return [];

    return movieVideos.value!.results
        .where((video) =>
            (video.type.toLowerCase() == 'trailer' ||
                video.type.toLowerCase() == 'teaser') &&
            video.site.toLowerCase() == 'youtube')
        .toList();
  }

  /// Check if movie data is loading
  bool get isLoading =>
      isLoadingDetail.value || isLoadingVideos.value || isLoadingImages.value;

  /// Check if there are any errors
  bool get hasAnyError =>
      hasDetailError.value || hasVideosError.value || hasImagesError.value;

  /// Get genre names as a string
  String get genreNames {
    if (movieDetail.value == null) return '';
    return movieDetail.value!.genres.map((genre) => genre.name).join(', ');
  }

  /// Get production companies as a string
  String get productionCompanies {
    if (movieDetail.value == null) return '';
    return movieDetail.value!.productionCompanies
        .map((company) => company.name)
        .join(', ');
  }

  @override
  void onClose() {
    // Clean up
    movieDetail.value = null;
    movieVideos.value = null;
    movieImages.value = null;
    super.onClose();
  }
}
