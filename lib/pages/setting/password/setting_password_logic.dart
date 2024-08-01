import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';

class SettingPasswordLogic extends GetxController {
  final mineLogic = Get.find<MineLogic>();
  late PageController pageController;
  final tabList = ["oldpwd", "privkey"].obs;
  final activeTab = 0.obs;
  final formByOldPwd = GlobalKey<FormBuilderState>();
  final formByPrivKey = GlobalKey<FormBuilderState>();
  final formByMnemonic = GlobalKey<FormBuilderState>();

  GlobalKey<FormBuilderState> _getCurFormKey() {
    final curItem = activeTab.value;
    if (curItem == 0) {
      return formByOldPwd;
    } else if (curItem == 1) {
      return formByPrivKey;
    } else if (curItem == 2) {
      return formByMnemonic;
    }

    return formByOldPwd;
  }

  void onChangedTab(int index) {
    activeTab.value = index;
  }

  void submit() {
    final formKey = _getCurFormKey();
    final valid = formKey.currentState?.saveAndValidate(focusOnInvalid: false);
    if (valid != null && valid) {
      final pwd = formKey.currentState?.getRawValue("new_password");
      mineLogic.savePassword(pwd);
      mineLogic.saveLastVerifyPwdTime();

      if (Get.context != null) {
        ToastHelper.showToast(Get.context!, "setting_password_success".tr);
      }
    }
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: activeTab.value);
    final mineLogic = Get.find<MineLogic>();
    if (mineLogic.currentWallet.value.isFromMnemonic) {
      tabList.add("mnemonic");
    }
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
