import 'package:get/get.dart';
import 'package:owlpro_app/pages/setting/setting_logic.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingLogic());
  }
}
