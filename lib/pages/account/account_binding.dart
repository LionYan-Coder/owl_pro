import 'package:get/get.dart';
import 'package:owlpro_app/pages/account/account_logic.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountLogic());
  }
}
