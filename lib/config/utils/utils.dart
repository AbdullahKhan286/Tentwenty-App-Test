import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/movie_detail_model.dart';
import '../constants/colors.dart';

class Utils {
  /// ========================= Show Success Snackbar ==============================
  static Color getGenreColor(String genreName) {
    switch (genreName.toLowerCase()) {
      case 'action':
        return AppColors.rosePink;
      case 'thriller':
        return AppColors.deepPurple;
      case 'science fiction':
      case 'sci-fi':
        return AppColors.skyBlue;
      case 'fiction':
        return AppColors.goldenrod;
      case 'adventure':
        return AppColors.turquoise;
      case 'drama':
        return AppColors.silverGray;
      case 'comedy':
        return AppColors.goldenrod;
      case 'horror':
        return AppColors.darkSlate;
      case 'romance':
        return AppColors.rosePink;
      case 'fantasy':
        return AppColors.deepPurple;
      default:
        return AppColors.silverGray;
    }
  }

  // /// ========================= Show Error Snackbar ==============================
  // static void showErrorSnackbar(String title, String message) {
  //   Get.closeAllSnackbars();
  //   Get.snackbar(
  //     title,
  //     message,
  //     backgroundColor: const Color(0xffFF0000),
  //     colorText: const Color(0xffFFFFFF),
  //     titleText:
  //         CustomText(text: title, fontSize: 20.sp, fontWeight: FontWeight.bold),
  //     messageText: CustomText(text: message, fontSize: 16.sp, maxLines: 3),
  //     icon: Icon(Icons.error, color: const Color(0xffFFFFFF), size: 30.sp),
  //   );
  // }

  // /// ========================= Show Info Snackbar ==============================
  static Future<void> urlLuncher(MovieVideo trailer) async {
    try {
      final url = Uri.parse(trailer.youtubeUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          "Error",
          "Could not open trailer",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.rosePink,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not open trailer",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.rosePink,
        colorText: Colors.white,
      );
    }
  }
}
