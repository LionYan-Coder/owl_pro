import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/user_profile/user_profile_logic.dart';
import 'package:owlpro_app/routes/app_routes.dart';

import 'widgets/add_friend_dialog.dart';

class UserProfilePage extends StatelessWidget {
  final logic = Get.find<UserProfileLogic>(tag: GetTags.userProfile);
  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "user_search_result_title".tr,
        backgroundColor: Styles.c_0C8CE9
            .withOpacity(0.1)
            .adapterDark(Styles.c_0C8CE9.withOpacity(0.2)),
      ),
      body: Obx(() {
        final user = logic.userInfo.value;
        return SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.only(top: 40.w, bottom: 12.w),
                      child: Column(
                        children: [
                          AvatarView(
                            radius: 32.w,
                            tag: user.nickname ?? 'avatar',
                            url: user.faceURL ?? '',
                            text: user.nickname ?? '',
                          ),
                          12.gapv,
                          (user.nickname ?? '').toText
                            ..style = Styles.ts_333333_18_medium
                                .adapterDark(Styles.ts_CCCCCC_18_medium),
                          12.gapv,
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
                          IconButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.userQRcode,
                                    arguments: logic.userInfo);
                              },
                              icon: "me_ico_code".svg.toSvg
                                ..width = 24.w
                                ..height = 24.w
                                ..color = Styles.c_333333
                                    .adapterDark(Styles.c_CCCCCC))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "identity_Id".tr.toText
                          ..style = Styles.ts_333333_16
                              .adapterDark(Styles.ts_CCCCCC_16),
                        (user.account ?? '').at.toText
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
                        AddressCopy(address: user.address ?? '')
                      ],
                    ),
                    32.gapv,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "me_ico_Wisdom".png.toImage
                          ..width = 16.w
                          ..height = 16.w
                          ..adpaterDark = true,
                        3.gaph,
                        Expanded(
                            child: (user.about != null && user.about!.isNotEmpty
                                    ? user.about
                                    : "identity_about_empty".tr)!
                                .toText
                              ..maxLines = 2
                              ..overflow = TextOverflow.ellipsis
                              ..style = Styles.ts_666666_12
                                  .adapterDark(Styles.ts_999999_12))
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 40.w, right: 40.w, top: 64.w),
                        child: "user_search_result_user_button".tr.toButton
                          ..onPressed = () async {
                            if (!user.isFriendship) {
                              final valid =
                                  await Get.dialog(AddFriendDialog(user: user));

                              if (valid == true) {
                                logic.addFriend();
                              }
                            } else {
                              logic.toChat();
                            }
                          })
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
