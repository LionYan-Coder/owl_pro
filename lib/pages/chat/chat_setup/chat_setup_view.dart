import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/setting/widgets/setting_menu.dart';

import 'chat_setup_logic.dart';

class ChatSetupPage extends StatelessWidget {
  ChatSetupPage({super.key});

  final logic = Get.find<ChatSetupLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildButtonsView(),
              _buildBaseInfoView(),
              Container(
                height: 1,
                color: Styles.c_F6F6F6.adapterDark(Styles.c_161616),
              ),
              _buildSettingsView()
            ],
          ),
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                left: 64.w,
                right: 64.w,
                bottom: context.mediaQueryPadding.bottom + 24.w,
                top: 24.w),
            child: "delete".tr.toButton
              ..variants = ButtonVariants.outline
              ..textStyle = Styles.ts_DE473E_16_medium
              ..onPressed = () => logic.deleteFromFriendList ),
      );
    });
  }

  Widget _buildButtonsView() {
    return Container(
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
            title: "user_profile_setup_title".tr,
            backgroundColor: Colors.transparent,
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.w),
            child: Column(
              children: [
                AvatarView(
                  radius: 32.w,
                  tag: logic.conversationInfo.value.userID ?? 'avatar',
                  url: logic.conversationInfo.value.faceURL ?? '',
                  text: logic.userInfo.value.nickname ?? '',
                ),
                12.gapv,
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child:
                      (logic.conversationInfo.value.showName ?? '').toText
                        ..style = Styles.ts_333333_18_medium
                            .adapterDark(Styles.ts_CCCCCC_18_medium),
                    ),
                    Positioned(
                        right: -10.w,
                        top: -4.h,
                        child: IconButton(
                            onPressed: logic.showRemarkInputDialog,
                            icon: "nvbar_edit".svg.toSvg
                              ..width = 16.w
                              ..height = 16.w
                              ..color =
                              Styles.c_333333.adapterDark(Styles.c_CCCCCC)))
                  ],
                ),
                12.gapv,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserOnlineDot(online: logic.statusInfo.value?.status == 1),
                  ],
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 24, horizontal: 40)
                      .w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _button(
                          icon: "info_ico_mute_nor", text: "meetingMute".tr),
                      _button(icon: "info_ico_seach", text: "search".tr),
                      _button(icon: "info_ico_share", text: "share_title".tr),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaseInfoView() {
    return Padding(
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
              (logic.userInfo.value.nickname ?? '').toText
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
              (logic.userInfo.value.account ?? '').at.toText
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
              AddressCopy(address: logic.userInfo.value.address ?? '')
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
                  child: (logic.userInfo.value.about != null &&
                      logic.userInfo.value.about!.isNotEmpty
                      ? logic.userInfo.value.about
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
    );
  }

  Widget _buildSettingsView(){
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.w),
      child: Column(
        children: [
          SettingMenu(label: "user_profile_setup_clear_history".tr),
          SettingMenu(label: "user_profile_setup_clear_read".tr),
          SettingMenu(label: "user_profile_setup_en_method".tr),
          SettingMenu(label: "user_profile_setup_ex_destroy".tr),
          SettingMenu(
            label: "user_profile_setup_add_black".tr,
            right: Switch(
                value: logic.userInfo.value.isBlacklist,
                onChanged: (_) => logic.toggleBlacklist()),
          )
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
