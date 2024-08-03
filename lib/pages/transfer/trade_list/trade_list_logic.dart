import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';

class TradeListLogic extends GetxController {
  final mineLogic = Get.find<MineLogic>();
  final imLogic = Get.find<IMController>();
  late Rx<TokenType> tokenType;
  final loading = false.obs;
  final tradeList = Rx<List<TokenTransaction>>([]);

  final currentTab = 0.obs;
  late PageController pageController;

  List<TokenTransaction> get filterList => currentTab.value == 1
      ? tradeList.value
          .where((item) => item.from.delPad == imLogic.userInfo.value.address)
          .toList()
      : (currentTab.value == 2
          ? tradeList.value
              .where((item) => item.to.delPad == imLogic.userInfo.value.address)
              .toList()
          : tradeList.value);

  BigInt get balance => tokenType.value == TokenType.owl
      ? mineLogic.currentBalance.value.owlBalance
      : mineLogic.currentBalance.value.olinkBalance;

  double get balanceToUSD => tokenType.value == TokenType.owl
      ? balance.toWei.owlToUsd
      : balance.toWei.olinkToUsd;

  Future<void> _fetchTx(String address) async {
    try {
      loading.value = true;
      final response = tokenType.value == TokenType.olink
          ? await Web3Util.getOlinkTxs(address: address)
          : await Web3Util.getOwlTxs(address: address);
      if (response.code == 0) {
        final List<TokenTransaction> list = response.list
            .map((item) => TokenTransaction.fromJson(item))
            .toList();
        tradeList.value = list;
      }
      tradeList.value = [];
    } catch (e) {
      Logger.print("TradeListLogic_fetchTx error = ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  bool isSend(TokenTransaction tx) {
    return imLogic.userInfo.value.address == tx.from.delPad;
  }

  void onChangeTab(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn);
    currentTab.value = index;
  }

  @override
  void onReady() {
    if (imLogic.userInfo.value.address != null) {
      _fetchTx(imLogic.userInfo.value.address!);
    }

    super.onReady();
  }

  @override
  void onInit() {
    tokenType = Rx<TokenType>(Get.arguments);
    pageController = PageController(initialPage: currentTab.value);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
