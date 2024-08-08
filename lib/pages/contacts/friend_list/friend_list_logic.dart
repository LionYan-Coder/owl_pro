import 'dart:async';

import 'package:azlistview/azlistview.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owlpro_app/core/controller/user_status_controller.dart';

class FriendListLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final userStatusLogic = Get.find<UserStatusController>();
  final userIDList = <String>[];
  late StreamSubscription delSub;
  late StreamSubscription addSub;
  late StreamSubscription infoChangedSub;
  final friendList = <ISUserInfo>[].obs;


  @override
  void onInit() {
    delSub = imLogic.friendDelSubject.listen(_delFriend);
    addSub = imLogic.friendAddSubject.listen(_addFriend);
    infoChangedSub = imLogic.friendInfoChangedSubject.listen(_friendInfoChanged);
    imLogic.onBlacklistAdd = _delFriend;
    imLogic.onBlacklistDeleted = _addFriend;
    super.onInit();
  }

  @override
  void onReady() {
    _getFriendList();
    super.onReady();
  }

  @override
  void onClose() {
    delSub.cancel();
    addSub.cancel();
    infoChangedSub.cancel();
    super.onClose();
  }

  _getFriendList() async {
    final list = await OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) => list.where(_filterBlacklist))
        .then((list) => list.map((e) {
              final fullUser = FullUserInfo.fromJson(e);
              final user = fullUser.friendInfo != null
                  ? ISUserInfo.fromJson(fullUser.friendInfo!.toJson())
                  : ISUserInfo.fromJson(fullUser.publicInfo!.toJson());
              return user;
            }).toList())
        .then((list) => IMUtils.convertToAZList(list));

    onUserIDList(userIDList);
    friendList.assignAll(list.cast<ISUserInfo>());
    friendList.insert(0, ISUserInfo.fromJson({"tagIndex": "↑"}));
  }

  void onUserIDList(List<String> userIDList) async {
    userStatusLogic.subUserStatus(userIDList);
  }

  bool _filterBlacklist(e) {
    final user = FullUserInfo.fromJson(e);
    final isBlack = user.blackInfo != null;

    if (isBlack) {
      return false;
    } else {
      userIDList.add(user.userID);
      return true;
    }
  }

  _addFriend(dynamic user) {
    if (user is FriendInfo || user is BlacklistInfo) {
      userStatusLogic.subUserStatus([user.userID]);
      _addUser(user.toJson());
    }
  }

  _delFriend(dynamic user) {
    if (user is FriendInfo || user is BlacklistInfo) {
      userStatusLogic.unSubUserStatus([user.userID]);
      friendList.removeWhere((e) => e.userID == user.userID);
    }
  }

  _friendInfoChanged(FriendInfo user) {
    friendList.removeWhere((e) => e.userID == user.userID);
    _addUser(user.toJson());
  }

  void _addUser(Map<String, dynamic> json) {
    final info = ISUserInfo.fromJson(json);
    friendList.add(IMUtils.setAzPinyinAndTag(info) as ISUserInfo);

    SuspensionUtil.sortListBySuspensionTag(friendList);

    SuspensionUtil.setShowSuspensionStatus(friendList);
  }

  // void viewFriendInfo(ISUserInfo info) => AppNavigator.startUserProfilePane(
  //       userID: info.userID!,
  //     );

  // void searchFriend() => AppNavigator.startSearchFriend();
}
