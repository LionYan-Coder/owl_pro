import 'package:get/get.dart';
import 'package:owlpro_app/pages/guide/guide_logic.dart';

class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GuideLogic());
  }
}
