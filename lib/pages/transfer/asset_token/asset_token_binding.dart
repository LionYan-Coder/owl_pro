import 'package:get/get.dart';
import 'package:owlpro_app/pages/transfer/asset_token/asset_token_logic.dart';

class AssetTokenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssetTokenLogic());
  }
}
