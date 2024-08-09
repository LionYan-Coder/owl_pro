import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/routes/app_routes.dart';
import 'package:owlpro_app/widgets/dialog.dart';

class MineLogic extends GetxController {
  static get to => Get.find<MineLogic>();
  final im = Get.find<IMController>();
  late StreamSubscription kickedOfflineSub;

  final loadingBalance = false.obs;

  late Worker _worker;

  final currentWallet = Wallet(address: '', privKey: '', mnemonic: '').obs;

  final currentBalance =
      Balance(owlBalance: BigInt.zero, olinkBalance: BigInt.zero).obs;

  String get currentPassword => DataSp.devicePassword ?? '';
  int get lastVerifyPwdTime => DataSp.lastVerifyPwdTime ?? 0;
  final verifyPwdGapTime = 0.obs;

  String get getAllBalance =>
      (currentBalance.value.olinkBalance.toWei.owlToUsd +
              currentBalance.value.owlBalance.toWei.olinkToUsd)
          .fixed2;

  Future<void> savePassword(String password) async {
    final encrypted = EncryptionHelper.encrypted64(password);
    DataSp.putDevicePasswrd(encrypted);
  }

  void saveLastVerifyPwdTime() async {
    final now = DateTime.now();
    await DataSp.putLastVerifyPwdTime(now.millisecondsSinceEpoch);
  }

  Future<void> loadedWalletBalance(UserFullInfo user) async {
    if (user.address != null && user.address!.isNotEmpty) {
      try {
        loadingBalance.value = true;
        final olinkBalance =
            await Web3Util.getBalance(address: user.address ?? '');
        final owlBalance = await Web3Util.getBalanceOfContract(
          address: user.address ?? '',
        );
        currentBalance.update((val) {
          val?.olinkBalance = olinkBalance;
          val?.owlBalance = owlBalance;
        });
      } catch (e) {
        Logger.print("MineLogic-loadedWalletBalance error = ${e.toString()}");
      } finally {
        loadingBalance.value = false;
      }
    }
  }

  void checkPassword() async {
    if (currentPassword.isEmpty) {
      final newPwd = await AuthDialog.showSetPassworddDialog();
      savePassword(newPwd);
      saveLastVerifyPwdTime();
    } else {
      Logger.print(
          "currentPassword = ${EncryptionHelper.decrypt64(currentPassword)}");
      if (lastVerifyPwdTime > 0 && verifyPwdGapTime.value > 0) {
        var lastChecked =
            DateTime.fromMillisecondsSinceEpoch(lastVerifyPwdTime);

        if (DateTime.now().difference(lastChecked).inMilliseconds >=
            verifyPwdGapTime.value) {
          final valid = await AuthDialog.showVerifyPasswordDialog();

          if (valid) {
            saveLastVerifyPwdTime();
          }
        }
      }
    }
  }

  void kickedOffline() async {
    Get.snackbar(StrRes.accountWarn, StrRes.accountException);
    PackageBridge.rtcBridge?.dismiss();
    await DataSp.removeLoginCertificate();
    Get.offAllNamed(AppRoutes.accountList);
  }

  @override
  void onReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPassword();
    });
    super.onReady();
  }

  @override
  void onInit() {
    kickedOfflineSub = im.onKickedOfflineSubject.listen((value) {
      kickedOffline();
    });
    _worker = ever(im.userInfo, (userInfo) {
      loadedWalletBalance(userInfo);
      if (userInfo.address != null) {
        currentWallet.value =
            Wallet.loadWalletFromHive(userInfo.address ?? '') as Wallet;
      }
      ;
    });
    currentWallet.value =
        Wallet.loadWalletFromHive(im.userInfo.value.address ?? '') ??
            Wallet(address: '', privKey: '', mnemonic: '');
    loadedWalletBalance(im.userInfo.value);
    verifyPwdGapTime.value =
        DataSp.verifyPwdGap ?? const Duration(milliseconds: 0).inMilliseconds;
    super.onInit();
  }

  @override
  void onClose() {
    kickedOfflineSub.cancel();
    _worker.dispose();
    super.onClose();
  }
}
