import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/chat/group_chat_setup/group_chat_setup_logic.dart';

class GroupChatSetupPage extends StatelessWidget {
  GroupChatSetupPage({super.key});

  final logic = Get.find<GroupChatSetupLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
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
                        title: "group_setup_title".tr,
                        backgroundColor: Colors.transparent,
                      ),
                      _buildBaseInfo()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Padding _buildBaseInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 40.w, bottom: 12.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: logic.modifyGroupAvatar,
            child: AvatarView(
              radius: 32.w,
              url: logic.groupInfo.value.faceURL,
              text: logic.groupInfo.value.groupName,
              textStyle: Styles.ts_FFFFFF_14,
            ),
          ),
          12.gapv,
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: (logic.groupInfo.value.groupName ?? '').toText
                  ..style = Styles.ts_333333_18_medium
                      .adapterDark(Styles.ts_CCCCCC_18_medium),
              ),
              Visibility(
                visible: logic.isOwnerOrAdmin,
                child: Positioned(
                    right: -10.w,
                    top: -10.w,
                    child: IconButton(
                        onPressed: () {},
                        // onPressed: logic.showRemarkInputDialog,
                        icon: "nvbar_edit".svg.toSvg
                          ..width = 16.w
                          ..height = 16.w
                          ..color =
                              Styles.c_333333.adapterDark(Styles.c_CCCCCC))),
              ),
            ],
          ),
          logic.isOwnerOrAdmin
              ? TextButton(
                  onPressed: () => logic.viewGroupMembers(),
                  child: "group_setup_view_member".tr.toText
                    ..style = Styles.ts_0C8CE9_12)
              : ("成员 ${logic.groupInfo.value.memberCount}".toText
                ..style = Styles.ts_0C8CE9_12),
          logic.isJoinedGroup.value
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 40)
                          .w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _button(
                          icon: "info_ico_mute_nor", text: "meetingMute".tr),
                      _button(icon: "info_ico_seach", text: "search".tr),
                      _button(icon: "info_ico_share", text: "share_title".tr),
                      _button(
                        text: "qrcode".tr,
                        icon: "me_ico_code",
                      ),
                    ],
                  ),
                )
              : IconButton(
                  onPressed: () {},
                  icon: "me_ico_code".svg.toSvg
                    ..width = 24.w
                    ..height = 24.w
                    ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC))
        ],
      ),
    );
  }

  Widget _button(
      {required String icon, required String text, VoidCallback? onPressed}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
                color: Styles.c_FFFFFF.adapterDark(Styles.c_262626),
                border: Border.all(
                    color: Styles.c_EDEDED.adapterDark(Styles.c_161616)),
                borderRadius: BorderRadius.circular(999)),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: icon.svg.toSvg
                  ..width = 18.w
                  ..height = 18.w
                  ..color = Styles.c_333333.adapterDark(Styles.c_999999),
              ),
            ),
          ),
        ),
        7.gapv,
        text.toText
          ..style = Styles.ts_666666_12.adapterDark(Styles.ts_999999_12)
      ],
    );
  }
}
