import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/routes/app_routes.dart';
import 'package:owlpro_app/widgets/dialog.dart';

import 'widgets/bottom_sheet.dart';

class AccountLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final loading = false.obs;

  void delAccount() async {
    try {
      loading.value = true;
      if (OpenIM.iMManager.isLogined) {
        await imLogic.logout();
      }
      if (imLogic.userInfo.value.address != null &&
          imLogic.userInfo.value.userID != null) {
        await DataSp.removeLoginCertificate();
        await DataSp.removeAccounts(imLogic.userInfo.value.userID!);
        await Wallet.deleteWallet(imLogic.userInfo.value.address!);
        Get.offAllNamed(AppRoutes.accountList);
      }
    } catch (e) {
      Logger.print("AccountLogic-delAccount ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  void showPrivateKey(Wallet wallet) async {
    final b = await AuthDialog.showVerifyPasswordDialog(close: true);
    if (b) {
      // isVerify.value = true;
      _showModalBottom(type: ModalType.privkey, content: wallet.privKey);
    }
    // if (isVerify.value = true) {
    //   _showModalBottom(type: ModalType.privkey, content: wallet.privKey);
    // } else {
    //   final b = await AuthDialog.showVerifyPasswordDialog(close: true);
    //   if (b) {
    //     isVerify.value = true;
    //     _showModalBottom(type: ModalType.privkey, content: wallet.privKey);
    //   }
    // }
  }

  void showMnemonic(Wallet wallet) async {
    final b = await AuthDialog.showVerifyPasswordDialog(close: true);
    if (b) {
      // isVerify.value = true;
      _showModalBottom(
          type: ModalType.mnemonic, content: wallet.mnemonic ?? '');
    }
    // if (isVerify.value = true) {
    //   _showModalBottom(
    //       type: ModalType.mnemonic, content: wallet.mnemonic ?? '');
    // } else {
    //   final b = await AuthDialog.showVerifyPasswordDialog(close: true);
    //   if (b) {
    //     isVerify.value = true;
    //     _showModalBottom(
    //         type: ModalType.mnemonic, content: wallet.mnemonic ?? '');
    //   }
    // }
  }

  void _showModalBottom({required ModalType type, required String content}) {
    Get.bottomSheet(WalletBottomSheet(type: type, content: content),
        backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)));
  }
}
