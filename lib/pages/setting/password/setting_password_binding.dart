import 'package:get/get.dart';
import 'package:owlpro_app/pages/setting/password/setting_password_logic.dart';

class SettingPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingPasswordLogic());
  }
}
