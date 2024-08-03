import 'package:get/get.dart';

import 'trade_detail_logic.dart';

class TradeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TradeDetailLogic());
  }
}
