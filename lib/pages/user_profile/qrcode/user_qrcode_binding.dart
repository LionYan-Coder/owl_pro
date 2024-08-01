import 'package:get/get.dart';
import 'package:owlpro_app/pages/user_profile/qrcode/user_qrcode_logic.dart';

class UserQrcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserQrcodeLogic());
  }
}
