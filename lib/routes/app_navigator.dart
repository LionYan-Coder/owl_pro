import 'package:get/get.dart';
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

  static void startRestoreCreate() {
    Get.toNamed(AppRoutes.loginRestore);
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

  static void startAccountList() {
    Get.toNamed(
      AppRoutes.accountList,
    );
  }

  static void startAccountInfo() {
    Get.toNamed(
      AppRoutes.accountInfo,
    );
  }

  static void startAccountInfoEdit() {
    Get.toNamed(
      AppRoutes.accountInfoEdit,
    );
  }

  static void startMineQRCode() {
    Get.toNamed(
      AppRoutes.mineQRcode,
    );
  }

  static void startSetting() {
    Get.toNamed(
      AppRoutes.setting,
    );
  }

  static void startSettingLanguage() {
    Get.toNamed(
      AppRoutes.settingLanguage,
    );
  }

  static void startSettingTheme() {
    Get.toNamed(
      AppRoutes.settingTheme,
    );
  }

  static void startNotify() {
    Get.toNamed(
      AppRoutes.notify,
    );
  }

  static void startAsset() {
    Get.toNamed(
      AppRoutes.asset,
    );
  }

  static void startTransfer() {
    Get.toNamed(
      AppRoutes.transfer,
    );
  }

  static void startReceipt() {
    Get.toNamed(
      AppRoutes.receipt,
    );
  }
}
