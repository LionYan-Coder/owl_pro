import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

const assetPanelOpers = ['send', 'receipt', 'swap', 'bills'];

class AssetBaseInfo extends StatelessWidget {
  AssetBaseInfo({super.key});

  final logic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16).w,
      decoration: BoxDecoration(
        color: Styles.c_F9F9F9.adapterDark(Styles.c_121212),
        border: Border.all(color: Styles.c_EDEDED.adapterDark(Styles.c_262626)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [assetBalance(context), assetOperations(context)],
      ),
    );
  }

  Widget assetBalance(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        AppNavigator.startAsset();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16).w,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Styles.c_EDEDED.adapterDark(Styles.c_262626)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "me_asset_panel_title".tr.toText
                  ..style = Styles.ts_333333_16_medium
                      .adapterDark(Styles.ts_CCCCCC_16_medium),
                16.gapv,
                Obx(() => Row(
                      children: [
                        Text(
                          (logic.currentBalance.value.olinkBalance.toWei
                                      .owlToUsd +
                                  logic.currentBalance.value.owlBalance.toWei
                                      .olinkToUsd)
                              .fixed2,
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
                              ..style = Styles.ts_0C8CE9_24_bold),
                      ],
                    ))
              ],
            ),
            "me_asset_panel_coin".png.toImage
              ..width = 64.w
              ..fit = BoxFit.cover
          ],
        ),
      ),
    );
  }

  Widget assetOperations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3).w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: assetPanelOpers
            .map((oper) => Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          onOperTap(oper);
                        },
                        child: 'wallet_img_$oper'.png.toImage
                          ..adpaterDark = true
                          ..width = 40.w
                          ..height = 40.w),
                    6.gapv,
                    'wallet_asset_$oper'.tr.toText
                      ..style =
                          Styles.ts_666666_12.adapterDark(Styles.ts_999999_12)
                  ],
                ))
            .toList(),
      ),
    );
  }

  void onOperTap(String oper) {
    switch (oper) {
      case 'send':
        AppNavigator.startTransfer();
        break;
      case 'receipt':
        AppNavigator.startReceipt();
      default:
    }
    //TODO 跳转
  }
}
