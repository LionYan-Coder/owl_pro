import 'package:get/get.dart';
import 'package:owlpro_app/pages/mine/qrcode/mine_qrcode_logic.dart';

class MineQrcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineQrcodeLogic());
  }
}
