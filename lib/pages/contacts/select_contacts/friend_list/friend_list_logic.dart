import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/contacts/friend_list/friend_list_logic.dart';

import '../select_contacts_logic.dart';

class SelectContactsFromFriendsLogic extends FriendListLogic {

  final selectContactsLogic = Get.find<SelectContactsLogic>();


  @override
  void onUserIDList(List<String> userIDList) {
    selectContactsLogic.updateDefaultCheckedList(userIDList);
    super.onUserIDList(userIDList);
  }

  bool get isSelectAll {
    if (selectContactsLogic.checkedList.isEmpty) {
      return false;
    } else if (operableList
        .every((item) => selectContactsLogic.isChecked(item))) {
      return true;
    } else {
      return false;
    }
  }

  Iterable<ISUserInfo> get operableList => friendList.where(_remove);

  bool _remove(ISUserInfo info) => !selectContactsLogic.isDefaultChecked(info);

  selectAll() {
    if (isSelectAll) {
      for (var info in operableList) {
        selectContactsLogic.removeItem(info);
      }
    } else {
      for (var info in operableList) {
        final isChecked = selectContactsLogic.isChecked(info);
        if (!isChecked) {
          selectContactsLogic.toggleChecked(info);
        }
      }
    }
  }
}
