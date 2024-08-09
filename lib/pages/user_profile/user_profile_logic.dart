import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/app_controller.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/conversation/conversation_logic.dart';
import 'package:owlpro_app/routes/app_routes.dart';
import 'package:owlpro_app/widgets/dialog.dart';

class UserProfileLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final conversationLogic = Get.find<ConversationLogic>();
  late Rx<UserFullInfo> userInfo;
  final groupUserNickname = "".obs;
  final remarkFormKey = GlobalKey<FormBuilderState>();

  String? groupID;
  bool? offAllWhenDelFriend = false;

  bool get isGroupMemberPage => null != groupID && groupID!.isNotEmpty;
  bool get isMyself => userInfo.value.userID == OpenIM.iMManager.userID;

  late StreamSubscription _friendAddedSub;
  late StreamSubscription _friendInfoChangedSub;

  bool get isFriendship => userInfo.value.isFriendship == true;

  final formKey = GlobalKey<FormBuilderState>(); //申请添加好友的表单

  void _getUsersInfo() async {
    final userID = userInfo.value.userID!;
    final list = await OpenIM.iMManager.userManager.getUsersInfoWithCache(
      [userID],
    );
    final list2 = await Apis.getUserFullInfo(userIDList: [userID]);
    final user = list.firstOrNull;
    final fullInfo = list2?.firstOrNull;

    final isFriendship = user?.friendInfo != null;
    final isBlack = user?.blackInfo != null;

    if (null != user && null != fullInfo) {
      userInfo.update((val) {
        val?.nickname = user.nickname;
        val?.faceURL = user.faceURL;
        val?.remark = user.friendInfo?.remark;
        val?.isBlacklist = isBlack;
        val?.isFriendship = isFriendship;
        val?.allowAddFriend = fullInfo.allowAddFriend;
        val?.account = fullInfo.account;
        val?.address = fullInfo.address;
        val?.about = fullInfo.about;
        val?.coverURL = fullInfo.coverURL;
      });
    }
  }

  void addFriend() async {
    try {
      final form = formKey.currentState;
      final reason = form?.getRawValue("reason");
      // final remark = form?.getRawValue("remark");
      await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.friendshipManager.addFriend(
            userID: userInfo.value.userID!, reason: reason.toString().trim()),
      );
      IMViews.showToast(StrRes.sendSuccessfully);
    } catch (_) {
      if (_ is PlatformException) {
        if (_.code == '${SDKErrorCode.refuseToAddFriends}') {
          IMViews.showToast(StrRes.canNotAddFriends);
          return;
        }
      }
      IMViews.showToast(StrRes.sendFailed);
    }
  }

  String getShowName() {
    if (isGroupMemberPage) {
      if (isFriendship) {
        if (null != IMUtils.emptyStrToNull(userInfo.value.remark)) {
          return '${groupUserNickname.value}(${IMUtils.emptyStrToNull(userInfo.value.remark)})';
        }
      }
      if (groupUserNickname.value.isEmpty) {
        return userInfo.value.nickname ??= "";
      }
      return groupUserNickname.value;
    }
    if (userInfo.value.remark != null && userInfo.value.remark!.isNotEmpty) {
      return '${userInfo.value.remark}';
    }
    return userInfo.value.nickname ?? '';
  }

  void toChat() {
    conversationLogic.toChat(
      userID: userInfo.value.userID,
      nickname: userInfo.value.showName,
      faceURL: userInfo.value.faceURL,
    );
  }


  void deleteFromFriendList() async {
    var confirm = await ConfirmDialog.showConfirmDialog(
        title: "delete_friend_confirm_title".tr,
        desc: "delete_friend_confirm_warning".tr);
    if (confirm) {
      await LoadingView.singleton.wrap(asyncFunction: () async {
        await OpenIM.iMManager.friendshipManager.deleteFriend(
          userID: userInfo.value.userID!,
        );
        userInfo.update((val) {
          val?.isFriendship = false;
        });

        final userIDList = [
          userInfo.value.userID,
          OpenIM.iMManager.userID,
        ];
        userIDList.sort();
        final conversationID = 'si_${userIDList.join('_')}';

        await OpenIM.iMManager.conversationManager
            .deleteConversationAndDeleteAllMsg(conversationID: conversationID);

        conversationLogic.list
            .removeWhere((e) => e.conversationID == conversationID);
      });

      if (offAllWhenDelFriend == true) {
        Get.until((route) => Get.currentRoute == AppRoutes.home);
      } else {
        Get.back();
      }
    }
  }

  @override
  void onReady() {
    _getUsersInfo();
    super.onReady();
  }

  @override
  void onInit() {
    userInfo = (UserFullInfo()
      ..userID = Get.arguments['userID']
      ..nickname = Get.arguments['nickname']
      ..faceURL = Get.arguments['faceURL'])
        .obs;
    groupID = Get.arguments['groupID'];
    offAllWhenDelFriend = Get.arguments['offAllWhenDelFriend'];
    _friendAddedSub = imLogic.friendAddSubject.listen((user) {
      if (user.userID == userInfo.value.userID) {
        userInfo.update((val) {
          val?.isFriendship = true;
        });
      }
    });
    _friendInfoChangedSub = imLogic.friendInfoChangedSubject.listen((user) {
      if (user.userID == userInfo.value.userID) {
        userInfo.update((val) {
          val?.nickname = user.nickname;
          val?.remark = user.remark;
        });
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    GetTags.destroyUserProfileTag();
    _friendAddedSub.cancel();
    _friendInfoChangedSub.cancel();
    // _memberInfoChangedSub.cancel();
    super.onClose();
  }
}
