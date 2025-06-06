import 'package:get/get.dart';
import 'package:tentwenty_app_test/presentation/screens/main/main_screen.dart';
import 'package:tentwenty_app_test/presentation/screens/movie_detail_screen/movie_detail_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import 'routes_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
            name: RoutesName.splashScreen, page: () => const SplashScreen()),
        GetPage(name: RoutesName.mainScreen, page: () => MainScreen()),
        GetPage(
            name: RoutesName.movieDetailScreen,
            page: () => MovieDetailScreen(
                movieId: Get.arguments)), // Placeholder for movie detail screen
      ];
}
