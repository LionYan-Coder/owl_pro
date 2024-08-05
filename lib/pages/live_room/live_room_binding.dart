import 'package:get/get.dart';
import 'package:owlpro_app/pages/live_room/live_room_logic.dart';

class LiveRoomBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => LiveRoomLogic());
  }
}