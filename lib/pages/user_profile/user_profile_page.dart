import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/user_profile/user_profile_logic.dart';

import 'widgets/add_friend_dialog.dart';

class UserProfilePage extends StatelessWidget {
  final logic = Get.find<UserProfileLogic>(tag: GetTags.userProfile);
  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = logic.userInfo;
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Styles.c_0C8CE9
                        .withOpacity(0.1)
                        .adapterDark(Styles.c_0C8CE9.withOpacity(0.2)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r))),
                child: Column(
                  children: [
                    TitleBar.back(
                      title: "user_search_result_title".tr,
                      backgroundColor: Colors.transparent,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.w, bottom: 12.w),
                      child: Column(
                        children: [
                          AvatarView(
                            radius: 32.w,
                            tag: user.value.nickname ?? 'avatar',
                            url: user.value.faceURL ?? '',
                            text: user.value.nickname ?? '',
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
                            child: (logic.getShowName() ?? '').toText
                              ..style = Styles.ts_333333_18_medium
                                  .adapterDark(Styles.ts_CCCCCC_18_medium),
                          ),
                          Container(
                            width: 50.w,
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                                color: Styles.c_0C8CE9.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(4.r)),
                            child: Center(
                                child:
                                    "user_search_result_user_status".tr.toText
                                      ..style = Styles.ts_0C8CE9_10),
                          ),
                          22.gapv,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 详情信息区
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "nickname".tr.toText
                          ..style = Styles.ts_333333_16
                              .adapterDark(Styles.ts_CCCCCC_16),
                        (user.value.nickname ?? '').toText
                          ..style = Styles.ts_666666_16
                              .adapterDark(Styles.ts_999999_16)
                      ],
                    ),
                    32.gapv,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "identity_Id".tr.toText
                          ..style = Styles.ts_333333_16
                              .adapterDark(Styles.ts_CCCCCC_16),
                        (user.value.account ?? '').at.toText
                          ..style = Styles.ts_666666_16
                              .adapterDark(Styles.ts_999999_16)
                      ],
                    ),
                    32.gapv,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "identity_address".tr.toText
                          ..style = Styles.ts_333333_16
                              .adapterDark(Styles.ts_CCCCCC_16),
                        AddressCopy(address: user.value.address ?? '')
                      ],
                    ),
                    32.gapv,
                    "identity_about_label".tr.toText
                      ..style =
                          Styles.ts_333333_16.adapterDark(Styles.ts_CCCCCC_16),
                    12.gapv,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "me_ico_Wisdom".png.toImage
                          ..width = 16.w
                          ..height = 16.w
                          ..adpaterDark = true,
                        3.gaph,
                        Expanded(
                            child: (user.value.about != null &&
                                        user.value.about!.isNotEmpty
                                    ? user.value.about
                                    : "identity_about_empty".tr)!
                                .toText
                              ..maxLines = 2
                              ..overflow = TextOverflow.ellipsis
                              ..style = Styles.ts_666666_12
                                  .adapterDark(Styles.ts_999999_12))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                left: 64.w,
                right: 64.w,
                bottom: context.mediaQueryPadding.bottom + 24.w,
                top: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (logic.isFriendship ?  "user_search_result_user_button" : "applyFriend") .tr.toButton
                  ..onPressed = () async {
                    if (!user.value.isFriendship) {
                      final valid =
                          await Get.dialog(AddFriendDialog(user: user.value));

                      if (valid == true) {
                        logic.addFriend();
                      }
                    } else {
                      logic.toChat();
                    }
                  },
                16.gapv,
                Visibility(
                    visible: logic.isFriendship,
                    child: "delete".tr.toButton
                      ..variants = ButtonVariants.outline
                      ..textStyle = Styles.ts_DE473E_16_medium
                      ..onPressed = () => logic.deleteFromFriendList()),
              ],
            )),
      );
    });
  }
}
