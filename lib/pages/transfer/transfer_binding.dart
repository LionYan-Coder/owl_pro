import 'package:get/get.dart';
import 'package:owlpro_app/pages/transfer/transfer_logic.dart';

class TransferBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => TransferLogic());
  }

}