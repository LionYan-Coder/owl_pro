import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class AddBySearchLogic extends GetxController {
  final loading = false.obs;
  final searchTextController = TextEditingController();
  final currentUser = Rx<UserFullInfo?>(null);

  void onSearch() {
    var searchValue = searchTextController.text;
    if (searchValue.trim().isNotEmpty) {
      if (searchValue.contains("oc")) {
        searchValue = searchValue.to0x;
      }
      searchUser(searchValue);
    }
  }

  Future<void> searchUser(String search) async {
    try {
      loading.value = true;
      final response = await Apis.searchUserByAccountOrAddress(
          address: search, account: search);

      currentUser.value = response;
    } catch (e) {
      Logger.print("AddBySearchLogic-searchUser error e=${e.toString()}");
      currentUser.value = null;
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
