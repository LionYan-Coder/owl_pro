import 'package:get/get.dart';
import 'package:owlpro_app/pages/setting/theme/setting_theme_logic.dart';

class SettingThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingThemeLogic());
  }
}
