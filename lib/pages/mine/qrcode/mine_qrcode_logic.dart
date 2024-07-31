import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class MineQrcodeLogic extends GetxController {
  Future<void> Function()? saveFunction;

  void save() {
    if (saveFunction != null) saveFunction!();
  }

  void share(String text) {
    Share.share(text);
  }
}
