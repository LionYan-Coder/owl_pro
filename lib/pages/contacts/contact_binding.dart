import 'package:get/get.dart';
import 'package:owlpro_app/pages/contacts/contact_logic.dart';
import 'package:owlpro_app/pages/contacts/friend_list/friend_list_logic.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FriendListLogic());
    Get.lazyPut(() => ContactLogic());
  }
}
