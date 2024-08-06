import 'package:get/get.dart';
import 'package:owlpro_app/pages/contacts/add_group/add_group_logic.dart';

class AddGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddGroupLogic());
  }
}
