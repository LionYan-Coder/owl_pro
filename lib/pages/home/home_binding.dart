import 'package:get/get.dart';
import 'package:owlpro_app/pages/contacts/contact_logic.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';

import '../conversation/conversation_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => ContactLogic());
    Get.lazyPut(() => ConversationLogic());
  }
}
