import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tentwenty_app_test/presentation/custom/custom_text/custom_text.dart';
import 'package:tentwenty_app_test/config/constants/colors.dart';
import '../../../config/routes/routes_name.dart';
import '../../../controller/incoming_movie_contoller/incoming_movie_contoller.dart';
import '../../../model/incoming_movies_model.dart';

class WatchScreen extends StatelessWidget {
  WatchScreen({super.key});

  final isSearchEnabled = false.obs;
  final searchController = TextEditingController();
  final incomingMovieController = Get.find<IncomingMovieController>();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        incomingMovieController.loadMoreMovies();
      }
    });

    return Scaffold(
      appBar: appBarContent(),
      body: bodyContent(),
    );
  }

  PreferredSizeWidget appBarContent() {
    return PreferredSize(
      preferredSize: Size.fromHeight(71.h),
      child: Obx(() {
        return AppBar(
          automaticallyImplyLeading: false,
          title: isSearchEnabled.value
              ? _buildSearchField()
              : const CustomText(text: "Watch"),
          actions: [
            if (isSearchEnabled.value)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  isSearchEnabled.value = false;
                  searchController.clear();
                  incomingMovieController.refreshMovies();
                },
              )
            else
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: AppColors.darkSlate,
                ),
                onPressed: () {
                  isSearchEnabled.value = true;
                  Future.delayed(const Duration(milliseconds: 100), () {
                    FocusScope.of(Get.context!).requestFocus(FocusNode());
                  });
                },
              ),
          ],
        );
      }),
    );
  }

  /// Search textField
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSilver,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: TextField(
        controller: searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "TV shows, movies and more",
          hintStyle: TextStyle(
            color: AppColors.silverGray,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.darkSlate,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
        ),
        style: TextStyle(
          color: AppColors.darkSlate,
          fontSize: 16.sp,
        ),
        onChanged: (value) {
          // Debounce search to avoid too many API calls
          // if (value.isEmpty) {
          //   incomingMovieController.refreshMovies();
          // } else {
          incomingMovieController.searchMovies(value);
          // }
        },
        // onSubmitted: (value) {
        //   incomingMovieController.searchMovies(value);
        // },
      ),
    );
  }

  Widget bodyContent() {
    return Obx(() {
      // Handle error state
      if (incomingMovieController.hasError.value) {
        return _buildErrorWidget();
      }

      // Handle initial loading state
      if (incomingMovieController.isLoading.value &&
          incomingMovieController.allMovies.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Handle empty state
      if (incomingMovieController.allMovies.isEmpty) {
        return _buildEmptyWidget();
      }

      return RefreshIndicator(
        onRefresh: incomingMovieController.refreshMovies,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: incomingMovieController.allMovies.length +
              (incomingMovieController.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the end
            if (index == incomingMovieController.allMovies.length) {
              return _buildLoadingMoreWidget();
            }

            // Trigger load more check
            incomingMovieController.checkForLoadMore(index);

            final movie = incomingMovieController.allMovies[index];
            return _buildMovieItem(movie, index);
          },
        ),
      );
    });
  }

  Widget _buildMovieItem(Movie movie, int index) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(RoutesName.movieDetailScreen, arguments: movie.id),
      child: Container(
        padding: EdgeInsets.only(top: 30.h, right: 20.w, left: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Stack(
                children: [
                  _buildMovieImage(movie.posterPath),
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: movie.title,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieImage(String? posterPath) {
    return posterPath != null
        ? Image.network(
            "https://image.tmdb.org/t/p/w500$posterPath",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 180.h,
            errorBuilder: (context, error, stackTrace) {
              return _buildImagePlaceholder(true);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildImagePlaceholder(false, loadingProgress);
            },
          )
        : _buildImagePlaceholder(true);
  }

  Widget _buildImagePlaceholder(bool isError,
      [ImageChunkEvent? loadingProgress]) {
    return Container(
      width: double.infinity,
      height: 180.h,
      color: AppColors.lightSilver,
      child: Center(
        child: isError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    color: AppColors.silverGray,
                    size: 50.sp,
                  ),
                  8.verticalSpace,
                  CustomText(
                    text: "Image not available",
                    color: AppColors.silverGray,
                    fontSize: 12,
                  ),
                ],
              )
            : CircularProgressIndicator(
                value: loadingProgress?.expectedTotalBytes != null
                    ? loadingProgress!.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                strokeWidth: 2.0,
                color: AppColors.skyBlue,
              ),
      ),
    );
  }

  Widget _buildLoadingMoreWidget() {
    return Container(
      padding: EdgeInsets.all(20.h),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.skyBlue,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: AppColors.silverGray,
          ),
          16.verticalSpace,
          CustomText(
            text: "Oops! Something went wrong",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkSlate,
          ),
          8.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: CustomText(
              text: incomingMovieController.errorMessage.value,
              fontSize: 14,
              color: AppColors.silverGray,
              textAlign: TextAlign.center,
            ),
          ),
          24.verticalSpace,
          ElevatedButton(
            onPressed: incomingMovieController.refreshMovies,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.skyBlue,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: CustomText(
              text: "Try Again",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 64.sp,
            color: AppColors.silverGray,
          ),
          16.verticalSpace,
          CustomText(
            text: "No movies found",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkSlate,
          ),
          8.verticalSpace,
          CustomText(
            text: "Try searching for something else",
            fontSize: 14,
            color: AppColors.silverGray,
          ),
        ],
      ),
    );
  }
}
