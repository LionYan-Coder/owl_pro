import 'package:get/get.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';

import '../mine/mine_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => MineLogic());
  }
}
