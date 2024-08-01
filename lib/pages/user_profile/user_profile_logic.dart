import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';

class UserProfileLogic extends GetxController {
  late Rx<UserFullInfo> userInfo;

  bool get isMyself => userInfo.value.userID == OwlIM.iMManager.userID;

  bool get isFriendship => userInfo.value.isFriendship == true;

  final formKey = GlobalKey<FormBuilderState>(); //申请添加好友的表单

  void _getUsersInfo() async {
    final userID = userInfo.value.userID!;
    final list = await OwlIM.iMManager.userManager.getUsersInfoWithCache(
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
      });
    }
  }

  void addFriend() async {
    try {
      final form = formKey.currentState;
      final reason = form?.getRawValue("reason");
      final remark = form?.getRawValue("remark");
      await LoadingView.singleton.wrap(
        asyncFunction: () => OwlIM.iMManager.friendshipManager.addFriend(
            userID: userInfo.value.userID!,
            reason: reason.toString().trim(),
            remark: remark),
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

  void toChat() {
    //TODO 去聊天
  }

  @override
  void onReady() {
    _getUsersInfo();
    super.onReady();
  }

  @override
  void onInit() {
    userInfo = Rx<UserFullInfo>(Get.arguments);
    super.onInit();
  }
}
