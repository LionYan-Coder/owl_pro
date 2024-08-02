import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
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

      Logger.print("imLogic user: ${imLogic.userInfo.value?.toJson()}");
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
        final data = await Apis.login(
            address: wallet?.address ?? '',
            nonce: bytesToHex(nonceHash, include0x: true),
            sign: signature);
        // ignore: unnecessary_null_comparison
        if (data.userID != null && data.userID.isNotEmpty) {
          await DataSp.addAccounts(data.userID);
          await DataSp.putLoginCertificate(data);
          if (OwlIM.iMManager.isLogined) {
            await imLogic.logout();
          }
          await imLogic.login(data.userID, data.imToken);
        }
      }
    } catch (e) {
      Logger.print("AccountListLogic onChangeUser error = ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    _init();
    super.onInit();
  }
}
