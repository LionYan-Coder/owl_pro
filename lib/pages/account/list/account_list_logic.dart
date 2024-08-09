import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/core/controller/push_controller.dart';
import 'package:owlpro_app/routes/app_navigator.dart';
import 'package:owlpro_app/routes/app_routes.dart';
import 'package:web3dart/crypto.dart';

class AccountListLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final accounts = RxList<UserFullInfo>([]);
  final pushLogic = Get.find<PushController>();

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

  void logout() async {
    try {
      await imLogic.logout();
      await DataSp.removeLoginCertificate();
      pushLogic.logout();
    } catch (e) {
      IMViews.showToast('e:$e');
    }
  }

  void onChangeUser(UserFullInfo user) async {
    try {
      final wallet = Wallet.loadWalletFromHive(user.address ?? '');
      final nonce = WalletUtil.generateRandomHex(32);
      final nonceHash = keccak256(Uint8List.fromList(utf8.encode(nonce)));
      final signature = wallet?.sign(nonceHash);
      logout();
      if (signature != null && signature.isNotEmpty) {
        LoadingView.singleton.wrap(asyncFunction: () async {
          final data = await Apis.login(
              publicKey: wallet?.publicKey ?? '',
              address: wallet?.address ?? '',
              nonce: bytesToHex(nonceHash, include0x: true),
              sign: signature);
          await DataSp.putLoginCertificate(data);
          await imLogic.login(data.userID, data.imToken);
          AppNavigator.startMain();
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
