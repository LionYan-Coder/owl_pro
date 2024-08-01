import 'package:get/get.dart';
import './add_by_search_logic.dart';

class AddBySearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddBySearchLogic());
  }
}
