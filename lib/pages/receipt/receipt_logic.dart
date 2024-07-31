import 'package:get/get.dart';

class ReceiptLogic extends GetxController {
  Future<void> Function()? saveFunction;

  void save() {
    if (saveFunction != null) saveFunction!();
  }
}
