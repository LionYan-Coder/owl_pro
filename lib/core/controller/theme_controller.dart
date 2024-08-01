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
    _changeSystemUI(theme);
  }

  void changeTheme(ThemeMode theme) async {
    Get.changeThemeMode(theme);
    _changeSystemUI(theme);
  }

  void _changeSystemUI(ThemeMode theme) {
    var brightness =
        theme == ThemeMode.dark ? Brightness.dark : Brightness.light;

    Future.delayed(const Duration(milliseconds: 250), () async {
      await Get.forceAppUpdate();
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
    _changeSystemUI(appTheme.value ?? ThemeMode.system);
    super.onInit();
  }
}
