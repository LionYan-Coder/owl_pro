import 'package:get/get.dart';
import 'package:owlpro_app/pages/transfer/trade_list/trade_list_logic.dart';

class TradeListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TradeListLogic());
  }
}
