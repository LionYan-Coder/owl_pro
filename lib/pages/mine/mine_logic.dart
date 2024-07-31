import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class MineLogic extends GetxController {
  static get to => Get.find<MineLogic>();
  final loadingWalletBalance = false.obs;

  final currentWallet = Wallet(address: '', privKey: '', mnemonic: '').obs;

  final currentBalance =
      Balance(owlBalance: BigInt.zero, olinkBalance: BigInt.zero).obs;

  String get password => DataSp.devicePassword ?? '';
  int get lastVerifyPwdTime => DataSp.lastVerifyPwdTime ?? 0;
  int get verifyPwdGapTime => DataSp.verifyPwdGap ?? 0;

  Future<void> savePassword(String password) async {
    final encrypted = EncryptionHelper.encrypted64(password);
    DataSp.putDevicePasswrd(encrypted);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
