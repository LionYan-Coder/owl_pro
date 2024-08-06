import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/routes/app_routes.dart';
import 'package:web3dart/crypto.dart';

class AccountListLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final accounts = RxList<UserFullInfo>([]);

  final loading = false.obs;

  void _init() async {
    try {
      loading.value = true;
      final userIDList = DataSp.getAccounts() ?? [];
      final users = await Apis.getUserFullInfo(userIDList: userIDList);
      users?.sort(
          (a, b) => b.createTime!.dateTime.compareTo(a.createTime!.dateTime));
      accounts.value = users ?? [];
    } catch (e) {
      Logger.print("AccountListLogic _init error = ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  void onChangeUser(UserFullInfo user) async {
    try {
      final wallet = Wallet.loadWalletFromHive(user.address ?? '');
      final nonce = WalletUtil.generateRandomHex(32);
      final nonceHash = keccak256(Uint8List.fromList(utf8.encode(nonce)));
      final signature = wallet?.sign(nonceHash);
      if (signature != null && signature.isNotEmpty) {
        LoadingView.singleton.wrap(asyncFunction: () async {
          final data = await Apis.login(
              publicKey: wallet?.publicKey ?? '',
              address: wallet?.address ?? '',
              nonce: bytesToHex(nonceHash, include0x: true),
              sign: signature);
          // ignore: unnecessary_null_comparison
          if (data.userID != null && data.userID.isNotEmpty) {
            await DataSp.addAccounts(data.userID);
            await DataSp.putLoginCertificate(data);
            if (OpenIM.iMManager.isLogined) {
              await imLogic.logout();
              await DataSp.removeLoginCertificate();
            }
            await imLogic.login(data.userID, data.imToken);
            await Get.forceAppUpdate();
            Get.offAndToNamed(AppRoutes.home);
          }
        });
      }
    } catch (e) {
      Logger.print("AccountListLogic onChangeUser error = ${e.toString()}");
    }
  }

  @override
  void onInit() {
    _init();
    super.onInit();
  }
}
