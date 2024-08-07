import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();
  ThemeMode appTheme = DataSp.appTheme ?? ThemeMode.system;

  bool get isDarkMode => appTheme == ThemeMode.dark;

  void toggleTheme() async {
    final theme = appTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    _changeSystemUI(theme);
  }

  void changeTheme(ThemeMode theme) async {
    Get.changeThemeMode(theme);
    _changeSystemUI(theme);
  }

  void _changeSystemUI(ThemeMode theme) async {
    appTheme = theme;
    Get.changeThemeMode(theme);
    Future.delayed(const Duration(milliseconds: 250), () async {
      await Get.forceAppUpdate();

      await DataSp.putTheme(theme);
      var brightness =
          theme == ThemeMode.dark ? Brightness.light : Brightness.dark;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
      ));
    });
  }

  @override
  void onInit() {
    // Logger.print("appTheme :${appTheme?.name}");
    _changeSystemUI(DataSp.appTheme ?? ThemeMode.system);
    super.onInit();
  }
}
