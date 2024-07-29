import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/routes/app_routes.dart';

class AppNavigator {
  AppNavigator._();

  static void startGuide() {
    Get.offAllNamed(AppRoutes.guide);
  }

  static void startLoginReady() {
    Get.offAllNamed(AppRoutes.loginReady);
  }

  static void startLoginCreate() {
    Get.toNamed(AppRoutes.loginCreate);
  }

  static void startLogin() {
    Get.toNamed(AppRoutes.login);
  }



  static void startMain({bool isAutoLogin = false}) {
    Get.offAllNamed(
      AppRoutes.home,
      arguments: {'isAutoLogin': isAutoLogin},
    );
  }

  static void startSplashToMain({bool isAutoLogin = false}) {
    Get.offAndToNamed(
      AppRoutes.home,
      arguments: {'isAutoLogin': isAutoLogin},
    );
  }
}
