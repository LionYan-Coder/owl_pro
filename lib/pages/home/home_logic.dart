import 'package:get/get.dart';

class HomeLogic extends GetxController {
  RxInt currentPage = 0.obs;

  List<String> tabs = [
    "tab_ico_chat",
    "tab_ico_intimate",
    "tab_ico_discover",
    "tab_ico_me"
  ];

  onChangePage(int index) {
    currentPage.value = index;
  }
}
