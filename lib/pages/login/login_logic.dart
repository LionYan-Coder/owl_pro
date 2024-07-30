import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:convert/convert.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:owl_common/owl_common.dart';
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

  create() async {
    String account = randString(6);
    String nickname = randString(6);
    String faceUrl = generateRandomHexColor();
    String publicKey = wallet.value!.publicKey;
    String address = wallet.value!.address;

    final WallteAccount wallteAccount = WallteAccount(
        publicKey: publicKey,
        address: address,
        nickname: nickname,
        account: account,
        faceURL: faceUrl);
    var walletBox = await Hive.openBox('Wallet');

    await wallteAccount.saveCurrentAccount(walletBox);
    await wallteAccount.addAccountToHive(walletBox);
    await wallet.value?.saveWalletToHive(walletBox);

    walletBox.close();

    final nonce = generateRandomHex(32);
    final nonceHash = keccak256(Uint8List.fromList(utf8.encode(nonce)));
    final signature = wallet.value?.sign(nonceHash);
    final data = await Apis.register(
        nonce: bytesToHex(nonceHash, include0x: true),
        sign: signature ?? '',
        nickname: nickname,
        account: account,
        address: address,
        publicKey: publicKey,
        faceURL: faceUrl);

    await DataSp.putLoginCertificate(data);
    await DataSp.putLoginAccount(wallteAccount.toJson());
    await imLogic.login(data.userID, data.imToken);
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

  String generateRandomHex(int length) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return hex.encode(bytes);
  }
}
