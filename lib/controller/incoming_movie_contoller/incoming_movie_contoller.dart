import 'package:get/get.dart';
import '../../model/incoming_movies_model.dart';
import '../../service/api_service.dart';

class IncomingMovieController extends GetxController {
  // Observable states
  Rxn<MovieResponse> incomingMovies = Rxn<MovieResponse>();
  RxList<Movie> allMovies = <Movie>[].obs;
  RxList<Movie> filteredMovies = <Movie>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxBool hasReachedEnd = false.obs;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    getIncomingMovies();
  }

  /// Initial load of movies
  Future<void> getIncomingMovies() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await ApiService.getUpcomingMovies(page: 1);

      incomingMovies.value = response;
      allMovies.value = response.results;
      _currentPage = response.page;
      _totalPages = response.totalPages;

      // Check if we've reached the end
      hasReachedEnd.value = _currentPage >= _totalPages;
    } catch (error) {
      hasError.value = true;
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more movies for pagination
  Future<void> loadMoreMovies() async {
    // Prevent multiple simultaneous calls
    if (isLoadingMore.value || hasReachedEnd.value) return;

    try {
      isLoadingMore.value = true;

      // Calculate next page
      final nextPage = _currentPage + 1;

      // Check if we can load more
      if (nextPage > _totalPages) {
        hasReachedEnd.value = true;
        return;
      }

      final response = await ApiService.getUpcomingMovies(page: nextPage);

      // Append new movies to existing list
      allMovies.addAll(response.results);

      // Update pagination info
      _currentPage = response.page;
      _totalPages = response.totalPages;

      // Update main response with latest data
      incomingMovies.value = incomingMovies.value?.copyWith(
        page: _currentPage,
        results: allMovies.toList(),
        totalPages: _totalPages,
      );

      // Check if we've reached the end
      hasReachedEnd.value = _currentPage >= _totalPages;
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to load more movies',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshMovies() async {
    _currentPage = 1;
    hasReachedEnd.value = false;
    allMovies.clear();
    await getIncomingMovies();
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      await refreshMovies();
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;

      // filter existing movies
      final filteredItem = allMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()) ||
              movie.overview.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // incomingMovies.value = incomingMovies.value?.copyWith(
      //   results: filteredMovies,
      // );
      filteredMovies.value = filteredItem;
    } catch (error) {
      hasError.value = true;
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if we should load more (called when user reaches near end of list)
  void checkForLoadMore(int index) {
    // Load more when user is 3 items away from the end
    if (index >= allMovies.length - 3 &&
        !isLoadingMore.value &&
        !hasReachedEnd.value) {
      loadMoreMovies();
    }
  }
}
