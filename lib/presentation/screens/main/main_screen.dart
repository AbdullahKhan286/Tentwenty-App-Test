import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/incoming_movie_contoller/incoming_movie_contoller.dart';
import '../watch_screen/watch_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final RxInt _currentIndex = 0.obs;
  final incomingMovieContoller = Get.put(IncomingMovieController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyContent(),
      bottomNavigationBar: bottomNavigationBarContent(),
    );
  }

  Widget bodyContent() {
    return Obx(() {
      return IndexedStack(
        index: _currentIndex.value,
        children: [
          Container(),
          WatchScreen(),
          Container(),
          Container(),
        ],
      );
    });
  }

  Widget bottomNavigationBarContent() {
    return Obx(() {
      return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(27.r),
        ),
        child: SizedBox(
          height: 90.h,
          child: BottomNavigationBar(
            currentIndex: _currentIndex.value,
            onTap: (value) => _currentIndex.value = value,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Icon(Icons.dashboard, size: 18.w),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Icon(Icons.watch, size: 18.w)),
                label: 'Watch',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Icon(Icons.medical_information, size: 18.w)),
                label: 'Media Library',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Icon(Icons.person, size: 18.w)),
                label: 'More',
              ),
            ],
          ),
        ),
      );
    });
  }
}
