import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

import '../../conversation/conversation_logic.dart';

class GroupListLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  final allList = <GroupInfo>[].obs;
  final searchCtrl = TextEditingController();
  final searchKey = "".obs;

  @override
  void onReady() {
    _getGroupRelatedToMe();
    super.onReady();
  }

  void _getGroupRelatedToMe() async {
    final list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
    allList.addAll(list);
  }

  void toGroupChat(GroupInfo info) {
    conversationLogic.toChat(
      offUntilHome: false,
      groupID: info.groupID,
      nickname: info.groupName,
      faceURL: info.faceURL,
      sessionType: info.sessionType,
    );
  }


  _search() {
    var key = searchCtrl.text.trim();
    searchKey.value = key;
  }


  @override
  void onInit() {
    searchCtrl.addListener(_search);
    super.onInit();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
