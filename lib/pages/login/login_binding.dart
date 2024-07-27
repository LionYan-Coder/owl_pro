import 'package:get/get.dart';
import 'package:owlpro_app/pages/login/login_logic.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginLogic());
  }
}
