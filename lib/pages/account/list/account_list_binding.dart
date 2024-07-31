import 'package:get/get.dart';
import 'package:owlpro_app/pages/account/list/account_list_logic.dart';

class AccountListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountListLogic());
  }
}
