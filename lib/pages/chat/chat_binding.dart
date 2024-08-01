import 'package:get/get.dart';
import 'package:owlpro_app/pages/chat/chat_logic.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatLogic());
  }
}
