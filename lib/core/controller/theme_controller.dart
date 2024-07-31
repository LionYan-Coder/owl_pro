import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();
  final appTheme = DataSp.appTheme.obs;

  void toggleTheme() async {
    final theme = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(theme);

    var brightness =
        theme == ThemeMode.dark ? Brightness.dark : Brightness.light;

    Future.delayed(const Duration(milliseconds: 250), () {
      Get.forceAppUpdate();
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
      ));
      appTheme.value = theme;
      DataSp.putTheme(theme);
      //
    });
  }

  @override
  void onInit() {
    // Logger.print("appTheme :${appTheme?.name}");
    appTheme.value = DataSp.appTheme;
    var brightness =
        appTheme.value == ThemeMode.dark ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
    super.onInit();
  }
}
