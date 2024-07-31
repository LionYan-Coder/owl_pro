import 'package:get/get.dart';
import 'package:owlpro_app/pages/receipt/receipt_logic.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReceiptLogic());
  }
}
