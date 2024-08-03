import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';

class TradeDetailLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  final txHash = ''.obs;
  late Rx<TokenType> token;
  final loading = false.obs;

  final tokenTransaction = Rx<TokenTransaction?>(null);

  Future<void> _fetchTxInfo() async {
    try {
      loading.value = true;
    } catch (e) {
      Logger.print("TradeDetailLogic_fetchTxInfo error = ${e.toString()}");
    } finally {
      loading.value = false;
    }
    final response = await Web3Util.getTx(txHash: txHash.value);
    if (response.code == 0 && response.result != null) {
      final txDataJson = response.result;
      tokenTransaction.value = TokenTransaction.fromJson(txDataJson);
    }
    tokenTransaction.value = null;
  }

  Future<void> _fetchTxs() async {
    try {
      loading.value = true;
      final response = await Web3Util.getOwlTxs(
          address: imLogic.userInfo.value.address ?? '');
      final response1 = await Web3Util.getTx(txHash: txHash.value);
      if (response.code == 0 && response1.code == 0) {
        final List<TokenTransaction> list = response.list
            .map((item) => TokenTransaction.fromJson(item))
            .toList();
        var tx = list.firstWhere((e) => e.hash == txHash.value);
        tokenTransaction.value = tx;
        final txDataJson = response1.result;
        var tx2 = TokenTransaction.fromJson(txDataJson);
        tokenTransaction.update((val) {
          val?.gasPrice = tx2.gasPrice;
        });
      }
      tokenTransaction.value = null;
    } catch (e) {
      Logger.print("TradeDetailLogic__fetchTxs error = ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  bool get isSend =>
      imLogic.userInfo.value.address == tokenTransaction.value?.from.delPad;

  @override
  void onReady() {
    if (token.value == TokenType.olink) {
      _fetchTxInfo();
    } else {
      _fetchTxs();
    }
    super.onReady();
  }

  @override
  void onInit() {
    token = Rx<TokenType>(Get.arguments);
    txHash.value = Get.parameters['txHash'] ?? '';
    super.onInit();
  }
}
