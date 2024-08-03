import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/pages/transfer/widgets/token_list_sheet.dart';
import 'package:owlpro_app/pages/transfer/widgets/transfer_result_sheet.dart';

class TransferLogic extends GetxController {
  final mineLogic = Get.find<MineLogic>();
  final imLogic = Get.find<IMController>();

  final formKey = GlobalKey<FormBuilderState>();
  final tokenType = TokenType.owl.obs;
  final maxFee = 0.0.obs;
  final loading = false.obs;
  final toAddress = ''.obs;

  final gasPrice = 10.obs;
  final gasLimit = 60000.obs;
  final gasLimitORC = 100000.obs;

  final txHash = "".obs;
  final resultMsg = "".obs;

  BigInt get balance => tokenType.value == TokenType.owl
      ? mineLogic.currentBalance.value.owlBalance
      : mineLogic.currentBalance.value.olinkBalance;

  void onChangeForm() {
    formKey.currentState?.save();
    final balance = formKey.currentState?.getRawValue("send_num");
    final fee = _calcFee(balance ?? "");
    maxFee.value = fee;
  }

  void onSubmit() {
    final state = formKey.currentState;
    final valid = state?.saveAndValidate(focusOnInvalid: false);
    if (valid == true) {
      final amount = state?.getRawValue("send_num");
      final address = state?.getRawValue("receipt_address");
      toAddress.value = address;
      _showTransferSheet(address: address, amount: amount);
      _transfer(amount);
    }
  }

  Future<void> _transfer(String amount) async {
    try {
      loading.value = true;
      final wallet = mineLogic.currentWallet.value;
      Result? response;
      if (tokenType.value == TokenType.owl) {
        response = await Web3Util.transferOfContract(
            fromAddress: wallet.address,
            toAddress: toAddress.value.to0x,
            privKey: wallet.privKey,
            amount: amount);
      } else if (tokenType.value == TokenType.olink) {
        response = await Web3Util.transfer(
            fromAddress: wallet.address,
            toAddress: toAddress.value.to0x,
            privKey: wallet.privKey,
            amount: amount);
      }

      if (response != null && response.code == 0) {
        txHash.value = response.result['result'] ?? '';
        mineLogic.loadedWalletBalance(imLogic.userInfo.value);
      } else {
        resultMsg.value = response?.msg ?? '';
      }
    } catch (e) {
      Logger.print("TransferLogic-_transfer error= ${e.toString()}");
      txHash.value = '';
      resultMsg.value = e.toString();
      return Future.error(e);
    } finally {
      loading.value = false;
    }
  }

  void _showTransferSheet(
      {required String address, required String amount}) async {
    await Get.bottomSheet(
      TransferResultSheet(),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
    );

    txHash.value = '';
    resultMsg.value = '';
  }

  void showSelectTokenSheet() {
    Get.bottomSheet(
      const TokenListSheet(),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
    );
  }

  void onTapAll() {
    formKey.currentState?.fields['send_num']?.didChange(balance);
  }

  void onChangeCoin(TokenType token) {
    tokenType.value = token;
    _randGas();
    _calcFee('0');
  }

  double _calcFee(String amount) {
    var fee = 0.00;

    if (tokenType.value == TokenType.olink) {
      if (amount.isNotEmpty) {
        fee = double.parse(amount) * 3 / 100;
        fee = fee +
            double.parse(
                Web3Util.calcFee(gasPrice.value, gasLimit.value).toString());
      }
    } else if (tokenType.value == TokenType.owl) {
      fee = double.parse(
          Web3Util.calcFee(gasPrice.value, gasLimit.value).toString());
    }

    return fee;
  }

  void _randGas() {
    final random = Random();

    gasPrice.value = random.nextInt(2) + 2;
    gasLimit.value = random.nextInt(20000) + 400000;

    gasLimitORC.value = random.nextInt(20000) + 100000;
    if (tokenType.value == TokenType.owl) {
      gasLimitORC.value = random.nextInt(20000) + 4000000;
    }
  }

  @override
  void onReady() {
    _randGas();
    super.onReady();
  }
}
