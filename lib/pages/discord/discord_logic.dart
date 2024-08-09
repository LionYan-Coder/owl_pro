import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscordLogic extends GetxController {
  final tabList = ["dynamic", "club", "web3"];
  final activeTab = 0.obs;
  late PageController pageController;


  void onChangedTab(int index) {
    activeTab.value = index;
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: activeTab.value);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
