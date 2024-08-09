import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

import 'discord_logic.dart';


class DiscordPage extends StatelessWidget {
  DiscordPage({Key? key}) : super(key: key);

  final logic = Get.find<DiscordLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavbarTabs(),
                _buildNavbarNotify()
              ],
            ),
            EmptyData(text: "wait_version".tr,)
          ],
        ),
      ),
    );
  }

  Widget _buildNavbarNotify() {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 24,top: 8).w,
      child: "navbar_ico_notification".svg.toSvg
        ..width = 24.w
        ..height = 24.w,
    );
  }

  Widget _buildNavbarTabs() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0).w,
      child: SizedBox(
        height: 24.w,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: logic.tabList.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 24.w),
            itemBuilder: (context, index) {
              final item = logic.tabList[index];
              return GestureDetector(
                onTap: () {
                  ToastHelper.showComingSoon();
                  logic.onChangedTab(index);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16).w,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                        color: logic.activeTab.value == index
                            ? Styles.c_333333
                            : Styles.c_999999.adapterDark(Styles.c_555555),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.16),
                    child: Text(
                      "discord_tab_$item".tr,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
