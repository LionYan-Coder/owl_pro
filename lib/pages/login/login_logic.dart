import 'dart:math';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

const accountStrs =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

class LoginLogic extends GetxController {
  final loading = false.obs;
  final checked = false.obs;
  final wallet = Rx<Wallet?>(null);

  createWallet() {
    Future.microtask(() {
      Future.delayed(const Duration(milliseconds: 400), () async {
        try {
          loading.value = true;
          wallet.value = await Wallet.createWallet();
          Logger.print("wallet create: ${wallet.toJson()}");
        } catch (e) {
          Logger.print("LoginLogic-createWallet error=${e.toString()}");
        } finally {
          loading.value = false;
        }
      });
    });
  }

  login() async {
    String account = randString(6);
    String nickname = randString(6);
    String faceUrl = generateRandomHexColor();
    String publicKey = wallet.value!.publicKey;
    String address = wallet.value!.address;

    final WallteAccount wallteAccount = WallteAccount(
        address: address,
        nickname: nickname,
        account: account,
        faceURL: faceUrl);
    var walletAccountsBox = await Hive.openBox('WallteAccounts');
    var walletAccountBox = await Hive.openBox<WallteAccount>('WallteAccount');
    var walletBox = await Hive.openBox<String>('Wallte');

    await wallteAccount.saveCurrentAccount(walletAccountBox);
    await wallteAccount.addAccountToHive(walletAccountsBox);
    await wallet.value?.saveWalletToHive(walletBox);

    walletAccountsBox.close();
    walletAccountBox.close();
    walletBox.close();
    Apis.register(
        nickname: nickname,
        account: account,
        address: address,
        publicKey: publicKey,
        faceURL: faceUrl);
    AppNavigator.startMain();
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
}
