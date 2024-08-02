import 'package:get/get.dart';
import 'package:owlpro_app/pages/account/edit/account_edit_logic.dart';

class AccountEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountEditLogic());
  }
}
