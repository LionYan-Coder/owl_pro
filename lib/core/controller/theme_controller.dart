import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();
  ThemeMode? get appTheme => DataSp.appTheme;

  void toggleTheme() async {
    final theme = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(theme);
    // Get.changeTheme(
    //     theme == ThemeMode.dark ? Styles.darkTheme : Styles.lightTheme);
    var brightness =
        theme == ThemeMode.dark ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
    Future.delayed(const Duration(milliseconds: 250), () {
      Get.forceAppUpdate();
      DataSp.putTheme(theme);
    });
  }

  @override
  void onInit() {
    Logger.print("appTheme :${appTheme?.name}");
    var brightness =
        appTheme == ThemeMode.dark ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
    super.onInit();
  }
}
