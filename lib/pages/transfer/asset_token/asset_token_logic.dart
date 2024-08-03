import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';

class AssetTokenLogic extends GetxController {
  final mineLogic = Get.find<MineLogic>();
  final currentTab = 0.obs;
  late PageController pageController;

  void onChangeTab(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn);
    currentTab.value = index;
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: currentTab.value);
    super.onInit();
  }
}
