import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/constants/colors.dart';
import '../../../config/utils/utils.dart';
import '../../../model/movie_detail_model.dart';
import '../../custom/custom_text/custom_text.dart';

void watchTrailer(MovieVideo trailer, BuildContext context) {
  // Show trailer options
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: AppColors.ghostWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.lightSilver,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: "Watch Trailer",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkSlate,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: trailer.name,
            fontSize: 14,
            color: AppColors.silverGray,
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.silverGray),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: CustomText(
                    text: "Cancel",
                    color: AppColors.silverGray,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Utils.urlLuncher(trailer);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.skyBlue,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: CustomText(
                    text: "Watch Now",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    ),
  );
}
