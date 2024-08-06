import 'package:get/get.dart';
import 'package:owlpro_app/pages/contacts/black_list/black_list_logic.dart';

class BlackListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BlackListLogic());
  }
}
