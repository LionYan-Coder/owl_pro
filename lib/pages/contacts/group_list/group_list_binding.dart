import 'package:get/get.dart';
import 'package:owlpro_app/pages/contacts/new_friend/new_friend_logic.dart';

class GroupListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewFriendLogic());
  }
}
