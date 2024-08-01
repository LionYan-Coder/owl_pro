import 'package:get/get.dart';
import 'package:owlpro_app/pages/setting/language/setting_language_logic.dart';

class SettingLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingLanguageLogic());
  }
}
