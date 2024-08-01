import 'package:get/get.dart';
import 'package:owlpro_app/pages/contacts/contact_logic.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactLogic());
  }
}
