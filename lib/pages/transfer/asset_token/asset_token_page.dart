import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/pages/transfer/asset_token/asset_token_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

final tabs = ["asset_tab_token", "asset_tab_nft"];

final tokens = ['open link', 'owl pro'];

class AssetTokenPage extends StatelessWidget {
  AssetTokenPage({super.key});

  final logic = Get.find<AssetTokenLogic>();
  final mineLogic = Get.find<MineLogic>();
  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "asset_title".tr,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24).w,
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                assetAllPanel(),
                32.gapv,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: TextTab(
                      items: tabs
                          .map((tab) => TextTabItem(
                              label: tab.tr, value: tabs.indexOf(tab)))
                          .toList(),
                      activeItem: logic.currentTab.value,
                      onChanged: (index) => logic.onChangeTab(index)),
                ),
                24.gapv,
                // Expanded(child: Container())
                Expanded(
                  child: PageView(
                    onPageChanged: (int index) =>
                        logic.currentTab.value = index,
                    controller: logic.pageController,
                    children: [tokenPage(), tokenPage()],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget tokenPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: TokenType.values.map((item) {
        final balance = item == TokenType.owl
            ? mineLogic.currentBalance.value.owlBalance
            : mineLogic.currentBalance.value.olinkBalance;
        final usd = item == TokenType.owl
            ? balance.toWei.owlToUsd
            : balance.toWei.olinkToUsd;
        if (balance > BigInt.zero) {
          return InkWell(
            onTap: () => AppNavigator.startTradeList(token: item),
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 24.0, left: 24, right: 24).w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      color: Styles.c_EDEDED.adapterDark(Styles.c_FFFFFF),
                      child: Center(
                          child: item.name.png.toImage
                            ..width = 32.w
                            ..fit = BoxFit.cover),
                    ),
                  ),
                  14.gaph,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.name.toUpperCase().toText
                        ..style = Styles.ts_333333_16_medium
                            .adapterDark(Styles.ts_CCCCCC_16_medium),
                      Container(
                          height: 16.w,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                              color: Styles.c_0C8CE9.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: (tokens[TokenType.values.indexOf(item)])
                              .toUpperCase()
                              .toText
                            ..style = Styles.ts_0C8CE9_10),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      balance.toWei.fixed6.toText
                        ..style = Styles.ts_333333_16_bold
                            .adapterDark(Styles.ts_CCCCCC_16_bold),
                      "≈\$${usd.fixed4}".toText
                        ..style =
                            Styles.ts_999999_12.adapterDark(Styles.ts_555555_12)
                    ],
                  ))
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }).toList(),
    );
  }

  Widget assetAllPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16).w,
        decoration: BoxDecoration(
            color: Styles.c_0C8CE9.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 24).w,
              margin: const EdgeInsets.only(bottom: 24).w,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: "0xFFDBF0FF"
                              .toColor
                              .adapterDark("0xFF152129".toColor)))),
              child: Row(
                children: [
                  AvatarView(
                    url: imLogic.userInfo.value.faceURL,
                    radius: 12,
                    text: imLogic.userInfo.value.nickname ?? '',
                    textStyle: TextStyle(
                      fontSize: 10.sp,
                    ),
                  ),
                  8.gaph,
                  AddressCopy(address: imLogic.userInfo.value.address ?? '')
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "asset_panel_all_title".tr.toText
                      ..style = Styles.ts_333333_16_medium
                          .adapterDark(Styles.ts_CCCCCC_16_medium),
                    16.gapv,
                    Row(
                      children: [
                        Text(
                          mineLogic.getAllBalance,
                          style: TextStyle(
                              fontSize: 40.sp,
                              height: 1.175,
                              fontWeight: FontWeight.bold,
                              color: Styles.c_0C8CE9),
                        ),
                        10.gaph,
                        Baseline(
                            baseline: 30.w,
                            baselineType: TextBaseline.alphabetic,
                            child: "USD".toText
                              ..style = Styles.ts_0C8CE9_24_bold)
                      ],
                    )
                  ],
                ),
                "me_asset_panel_coin".png.toImage
                  ..width = 64.w
                  ..fit = BoxFit.cover
              ],
            )
          ],
        ),
      ),
    );
  }
}
