import 'package:get/get.dart';
import 'package:owlpro_app/pages/chat/group_chat_setup/group_chat_setup_logic.dart';

class GroupChatSetupBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => GroupChatSetupLogic());
  }

}