import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/app_controller.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/conversation/conversation_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';
import 'package:owlpro_app/routes/app_routes.dart';
import 'package:owlpro_app/widgets/dialog.dart';

class UserProfileLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final conversationLogic = Get.find<ConversationLogic>();
  late Rx<UserFullInfo> userInfo;
  final iAmOwner = false.obs;
  final mutedTime = "".obs;
  final onlineStatus = false.obs;
  final onlineStatusDesc = ''.obs;
  final groupUserNickname = "".obs;
  final remarkFormKey = GlobalKey<FormBuilderState>();

  String? groupID;
  bool? offAllWhenDelFriend = false;


  bool get isGroupMemberPage => null != groupID && groupID!.isNotEmpty;
  bool get isMyself => userInfo.value.userID == OpenIM.iMManager.userID;

  late StreamSubscription _friendAddedSub;
  late StreamSubscription _friendInfoChangedSub;
  // late StreamSubscription _memberInfoChangedSub;

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


  void showRemarkInputDialog() async {
    final b = await Get.dialog<bool>(
      AlertDialog(
        insetPadding: const EdgeInsets.all(24).w,
        titlePadding: const EdgeInsets.only(left: 24, right: 24).w,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32).w,
              child: "user_profile_setup_set_remark_title".tr.toText
                ..style = Styles.ts_333333_18_bold
                    .adapterDark(Styles.ts_CCCCCC_18_bold),
            ),
            GestureDetector(
              onTap: () {
                Get.back(result: false);
              },
              child: "close".svg.toSvg
                ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
            )
          ],
        ),
        backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        content: SizedBox(
          width: 0.85.sw,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              18.gapv,
              FormBuilder(
                initialValue: {
                  "remark":getShowName()
                },
                  key: remarkFormKey,
                  child: Input(
                    name: "remark",
                    hintText: "user_profile_setup_set_remark_hint".tr,
                  )),
              28.gapv,
              Padding(
                padding: const EdgeInsets.only(bottom: 8).w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                        child: "cancel".tr.toButton
                          ..variants = ButtonVariants.outline
                          ..onPressed = () => Get.back(result: false)),
                    8.gaph,
                    Flexible(
                        child: "save".tr.toButton
                          ..onPressed = () {
                            final valid = remarkFormKey.currentState
                                ?.saveAndValidate(focusOnInvalid: false);

                            if (valid == true) {
                              Get.back(result: true);
                            }
                          }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    if (b == true) {
      final remark = remarkFormKey.currentState?.getRawValue("remark") as String;
      await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.friendshipManager.setFriendRemark(
          userID: userInfo.value.userID!,
          remark: remark.trim(),
        ),
      );
    }
  }

  Future<void> toggleBlacklist() async {
    final result = await OpenIM.iMManager.friendshipManager.checkFriend(userIDList: [userInfo.value.userID ?? '']);
    if (result.first.result == 1) {
      addBlacklist();
    } else {
      removeBlacklist();
    }
  }

  void addBlacklist() async {
    await OpenIM.iMManager.friendshipManager.addBlacklist(
      userID: userInfo.value.userID!,
    );
    userInfo.update((val) {
      val?.isBlacklist = true;
    });
  }

  void removeBlacklist() async {
    await OpenIM.iMManager.friendshipManager.removeBlacklist(
      userID: userInfo.value.userID!,
    );
    userInfo.update((val) {
      val?.isBlacklist = false;
    });
  }

  void deleteFromFriendList() async {
    var confirm = await ConfirmDialog.showConfirmDialog(title: "delete_friend_confirm_title".tr,desc: "delete_friend_confirm_warning".tr);
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

        await OpenIM.iMManager.conversationManager.deleteConversationAndDeleteAllMsg(conversationID: conversationID);

        conversationLogic.list.removeWhere((e) => e.conversationID == conversationID);
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
    userInfo = Rx<UserFullInfo>(Get.arguments);
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
