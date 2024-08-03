import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/transfer/transfer_logic.dart';

class TransferResultSheet extends StatelessWidget {
  TransferResultSheet({super.key});

  final logic = Get.find<TransferLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSuccessful = logic.txHash.value.isNotEmpty;
      var title = "send_coin_transfer_sending_title";
      if (logic.loading.value) {
        title = "send_coin_transfer_sending_title";
      } else if (logic.txHash.value.isEmpty) {
        title = "send_coin_transfer_error_title";
      } else if (isSuccessful) {
        title = "send_coin_transfer_successful_title";
      }
      return Padding(
        padding: EdgeInsets.only(
                left: 64,
                right: 64,
                top: 32,
                bottom: context.mediaQueryPadding.bottom)
            .w,
        child: SizedBox(
          height: 450.w,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: logic.txHash.value.isNotEmpty
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: "send_sending".png.toImage
                        ..width = 100.w
                        ..fit = BoxFit.cover,
                      secondChild: "send_succeful".png.toImage
                        ..width = 100.w
                        ..fit = BoxFit.cover,
                    ),
                    16.gapv,
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: title.tr.toText
                          ..style = Styles.ts_333333_20_bold
                              .adapterDark(Styles.ts_0C8CE9_20_bold)),
                    16.gapv,
                    isSuccessful
                        ? Text(
                            "send_coin_transfer_successful_label".tr,
                            style: Styles.ts_999999_14
                                .adapterDark(Styles.ts_555555_14),
                          ).animate().fadeIn()
                        : Text(
                            logic.resultMsg.value,
                            style: Styles.ts_999999_14
                                .adapterDark(Styles.ts_555555_14),
                          ).animate().fadeIn(),
                    isSuccessful
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                                    top: 3, bottom: 3, left: 4, right: 4)
                                .w,
                            margin: const EdgeInsets.symmetric(vertical: 4).w,
                            decoration: BoxDecoration(
                                color: Styles.c_0C8CE9.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(4.r)),
                            child: EllipsizedText(
                              logic.toAddress.value,
                              type: EllipsisType.middle,
                              style: Styles.ts_0C8CE9_14,
                            ),
                          ).animate().fadeIn()
                        : const SizedBox.shrink()
                  ],
                ),
                Column(
                  children: [
                    "send_coin_transfer_button".tr.toButton
                      ..onPressed = () => (Get.back()),
                    Visibility(
                      visible: logic.txHash.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24).w,
                        child: TextButton(
                            onPressed: () {
                              Get.back();
                              // Get.toNamed(AppRouter.assetTradeDetailName,
                              //     extra: coinType,
                              //     pathParameters: {
                              //       "txHash": data?.result['result'] ?? ''
                              //     });
                            },
                            child: "send_coin_transfer_to_trade".tr.toText
                              ..style = Styles.ts_666666_14_medium
                                  .adapterDark(Styles.ts_999999_14_medium)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
