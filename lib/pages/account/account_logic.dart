import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/widgets/dialog.dart';

import 'widgets/bottom_sheet.dart';

class AccountLogic extends GetxController {
  // final isVerify = false.obs;

  void delAccount() {}

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
