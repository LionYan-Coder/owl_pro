import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';

enum BalanceType { balance, balanceOfContract, balanceOfAll }

class MineLogic extends GetxController {
  static get to => Get.find<MineLogic>();
  final im = Get.find<IMController>();

  final loadingBalance = false.obs;

  late Worker _worker;

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

  Future<void> loadedWalletBalance(UserFullInfo user) async {
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

  @override
  void onInit() {
    super.onInit();

    _worker = ever(im.userInfo, (userInfo) {
      if (userInfo != null) {
        loadedWalletBalance(userInfo);
      }
    });
  }

  @override
  void onClose() {
    _worker.dispose();
    super.onClose();
  }
}
