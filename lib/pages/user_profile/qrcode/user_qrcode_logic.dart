import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:share_plus/share_plus.dart';

class UserQrcodeLogic extends GetxController {
  Future<void> Function()? saveFunction;
  late Rx<UserFullInfo> user;

  void save() {
    if (saveFunction != null) saveFunction!();
  }

  void share(String text) {
    Share.share(text);
  }

  @override
  void onInit() {
    user = Rx<UserFullInfo>(Get.arguments);
    super.onInit();
  }

  @override
  void onClose() {
    GetTags.destoryUserProfileQRTag();
    super.onClose();
  }
}
