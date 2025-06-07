import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tentwenty_app_test/config/constants/colors.dart';
import 'package:tentwenty_app_test/config/utils/utils.dart';
import 'package:tentwenty_app_test/presentation/custom/custom_text/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/movie_detail_controller/movie_detail_controller.dart';
import '../../../model/movie_detail_model.dart';
import 'watch_trailer_sheet.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final MovieDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MovieDetailController());
    controller.loadMovieData(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading && controller.movieDetail.value == null) {
          return _buildLoadingState();
        }

        if (controller.hasDetailError.value &&
            controller.movieDetail.value == null) {
          return _buildErrorState();
        }

        return _buildMovieDetailContent();
      }),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppColors.darkSlate,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.skyBlue,
          strokeWidth: 2.0,
          backgroundColor: AppColors.darkSlate,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: AppColors.darkSlate,
      child: Center(
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
              text: "Failed to load movie details",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.ghostWhite,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () => controller.refreshMovieData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
              ),
              child: const CustomText(
                text: "Try Again",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetailContent() {
    final movie = controller.movieDetail.value!;

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(movie),
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.ghostWhite,
            child: Column(
              children: [
                // _buildMovieInfo(movie),
                _buildActionButtons(),
                _buildGenres(movie),
                _buildOverview(movie),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(MovieDetail movie) {
    return SliverAppBar(
      expandedHeight: 0.5.sh,
      pinned: true,
      backgroundColor: AppColors.darkSlate,
      leading: Container(
        margin: EdgeInsets.all(8.r),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.ghostWhite,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            movie.fullBackdropUrl.isNotEmpty
                ? Image.network(
                    movie.fullBackdropUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkSlate,
                        child: Icon(
                          Icons.movie,
                          size: 100.sp,
                          color: AppColors.silverGray,
                        ),
                      );
                    },
                  )
                : Container(
                    color: AppColors.darkSlate,
                    child: Icon(
                      Icons.movie,
                      size: 100.sp,
                      color: AppColors.silverGray,
                    ),
                  ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(170),
                  ],
                ),
              ),
            ),

            // Movie title at bottom
            Positioned(
              bottom: 80.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: movie.title,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ghostWhite,
                  ),
                  8.verticalSpace,
                  CustomText(
                    text: "In Theaters ${movie.formattedReleaseDate}",
                    fontSize: 16,
                    color: AppColors.ghostWhite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: Column(
        children: [
          20.verticalSpace,
          // Get Tickets Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                // Handle get tickets action
                Get.snackbar(
                  "Get Tickets",
                  "Redirecting to ticket booking...",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.skyBlue,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.skyBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: CustomText(
                text: "Get Tickets",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          12.verticalSpace,

          // Watch Trailer Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: Obx(() {
              final trailer = controller.mainTrailer;
              return OutlinedButton.icon(
                onPressed: trailer != null
                    ? () => watchTrailer(trailer, context)
                    : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: trailer != null
                        ? AppColors.darkSlate
                        : AppColors.silverGray,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                icon: Icon(
                  Icons.play_arrow,
                  color: trailer != null
                      ? AppColors.darkSlate
                      : AppColors.silverGray,
                ),
                label: CustomText(
                  text: trailer != null
                      ? "Watch Trailer"
                      : "Trailer Not Available",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: trailer != null
                      ? AppColors.darkSlate
                      : AppColors.silverGray,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGenres(MovieDetail movie) {
    return Container(
      margin: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: "Genres",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkSlate,
              ),
              const Spacer(),
            ],
          ),
          12.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: movie.genres.map((genre) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Utils.getGenreColor(genre.name),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: genre.name,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(MovieDetail movie) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Overview",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkSlate,
          ),
          12.verticalSpace,
          CustomText(
            text: movie.overview.isNotEmpty
                ? movie.overview
                : "No overview available",
            fontSize: 14,
            color: AppColors.silverGray,
            maxLines: 100,
          ),
          150.verticalSpace,
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<MovieDetailController>();
    super.dispose();
  }
}
