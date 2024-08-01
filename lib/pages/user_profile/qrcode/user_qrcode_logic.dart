import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:share_plus/share_plus.dart';

class UserQrcodeLogic extends GetxController {
  Future<void> Function()? saveFunction;
  final user = Rx<UserFullInfo?>(null);

  void save() {
    if (saveFunction != null) saveFunction!();
  }

  void share(String text) {
    user.value = Get.arguments;
    Share.share(text);
  }
}
