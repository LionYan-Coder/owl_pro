import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/routes/app_navigator.dart';
import 'package:web3dart/crypto.dart';

const accountStrs =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

class LoginLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final loading = false.obs;
  final checked = false.obs;
  final wallet = Rx<Wallet?>(null);

  late PageController pageController;
  final restoreformKey = GlobalKey<FormBuilderState>();

  final restoreActiveTab = 0.obs;
  final List<String> restoreTabs = ['privkey', 'mnemonic'];

  createWallet() async {
    try {
      loading.value = true;
      wallet.value = await Wallet.createWallet();
      Logger.print("wallet create: ${wallet.toJson()}");
    } catch (e) {
      Logger.print("LoginLogic-createWallet error=${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  startRestore() async {
    final tab = restoreTabs[restoreActiveTab.value];
    final field = restoreformKey.currentState?.fields[tab];

    if (field != null) {
      final valid = field.validate(focusOnInvalid: false);
      if (valid) {
        field.save();
        final String? fieldValue = field.value;
        Wallet? restoreWallet;
        if (restoreTabs[restoreActiveTab.value] == 'privkey') {
          restoreWallet = Wallet.restoreFromPrivateKey(fieldValue ?? '');
        } else {
          restoreWallet = Wallet.restoreFromMnemonic(fieldValue ?? '');
        }

        if (restoreWallet != null) {
          _restoreWallet(restoreWallet);
        }
      }
    }
  }

  registerWallet(Wallet registerWallet) async {
    try {
      loading.value = true;
      String account = randString(6);
      String nickname = randString(6);
      String faceUrl = generateRandomHexColor();
      String publicKey = registerWallet.publicKey;
      String address = registerWallet.address;

      await registerWallet.saveWalletToHive();
      final nonce = WalletUtil.generateRandomHex(32);
      final nonceHash = keccak256(Uint8List.fromList(utf8.encode(nonce)));
      final signature = registerWallet.sign(nonceHash);
      final data = await Apis.register(
          nonce: bytesToHex(nonceHash, include0x: true),
          sign: signature,
          nickname: nickname,
          account: account,
          address: address,
          publicKey: publicKey,
          faceURL: faceUrl);

      await DataSp.addAccounts(data.userID);
      await DataSp.putLoginCertificate(data);
      if (OwlIM.iMManager.isLogined) {
        await imLogic.logout();
      }

      await imLogic.login(data.userID, data.imToken);
      AppNavigator.startMain();
    } catch (e) {
      Logger.print("Loginlogic-registerWallet error= ${e.toString()}",
          isError: true);
    } finally {
      loading.value = false;
    }
  }

  _restoreWallet(Wallet restoreWallet) async {
    try {
      loading.value = true;
      final nonce = WalletUtil.generateRandomHex(32);
      final nonceHash = keccak256(Uint8List.fromList(utf8.encode(nonce)));
      final signature = restoreWallet.sign(nonceHash);
      final data = await Apis.login(
          address: restoreWallet.address,
          nonce: bytesToHex(nonceHash, include0x: true),
          sign: signature);
      // ignore: unnecessary_null_comparison
      if (data.userID != null && data.userID.isNotEmpty) {
        await restoreWallet.saveWalletToHive();
        await DataSp.addAccounts(data.userID);
        await DataSp.putLoginCertificate(data);
        if (OwlIM.iMManager.isLogined) {
          await imLogic.logout();
        }
        await imLogic.login(data.userID, data.imToken);
        AppNavigator.startMain();
      } else {
        await registerWallet(restoreWallet);
      }
    } catch (e) {
      if (e.toString().contains("AccountNotFound")) {
        await registerWallet(restoreWallet);
      } else {
        Logger.print("LoginLogic_restoreWallet error = ${e.toString()}");
      }
    } finally {
      loading.value = false;
    }
  }

  String randString(int n) {
    String str = "";
    for (var i = 0; i < n; i++) {
      str = str + accountStrs[Random().nextInt(accountStrs.length)];
    }
    return str;
  }

  String generateRandomHexColor() {
    var r = Random().nextInt(256);
    var g = Random().nextInt(256);
    var b = Random().nextInt(256);
    return '0x${Color.fromRGBO(r, g, b, 1).value.toRadixString(16)}';
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: restoreActiveTab.value);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
