import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/transfer/trade_detail/trade_detail_logic.dart';
import 'package:url_launcher/url_launcher.dart';

const browserTxUrl = "https://owblockweb.owopenlinkoracle.com/tx.html";

class TradeDetailPage extends StatelessWidget {
  TradeDetailPage({super.key});

  final logic = Get.find<TradeDetailLogic>();
  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "asset_trade_detail_title".tr,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24).w,
          child: Obx(() {
            if (logic.loading.value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (!logic.loading.value && logic.tokenTransaction.value == null) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24).w,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Styles.c_F6F6F6
                                      .adapterDark(Styles.c_161616)))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          "transaction_ico_fail".svg.toSvg
                            ..width = 44.w
                            ..height = 44.w,
                          14.gapv,
                          "asset_trade_detail_fail".tr.toText
                            ..style = Styles.ts_DE473E_14_bold,
                          16.gapv,
                          logic.token.value.name.toUpperCase().toText
                            ..style = Styles.ts_999999_14
                        ],
                      ),
                    )
                  ],
                ),
              );
            }

            if (logic.tokenTransaction.value != null) {
              return Column(
                children: [txAmount(), txAddress(), txDetail(), txBrowserUrl()],
              );
            }
            return const SizedBox.shrink();
          })),
    );
  }

  Widget txAmount() {
    final amount = logic.tokenTransaction.value?.value ?? '0x0';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24).w,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
      child: Column(
        children: [
          "transaction_ico_success".svg.toSvg
            ..width = 44.w
            ..height = 44.w,
          14.gapv,
          "asset_trade_detail_success".tr.toText
            ..style = Styles.ts_1ED386_14_bold,
          16.gapv,
          ((logic.isSend ? '-' : '+') + amount.hextobigInt.toWei.fixed4).toText
            ..style =
                Styles.ts_333333_28_bold.adapterDark(Styles.ts_CCCCCC_28_bold),
          8.gapv,
          logic.token.value.name.toUpperCase.toString().toText
            ..style = Styles.ts_999999_14
        ],
      ),
    );
  }

  Widget txAddress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24).w,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("asset_trade_detail_sender"),
          AddressCopy(
            address: logic.tokenTransaction.value!.from.delPad,
            width: 243.w,
          ),
          24.gapv,
          label("asset_trade_detail_receipt"),
          AddressCopy(
            address: logic.tokenTransaction.value!.to.toOc,
            width: 243.w,
          ),
        ],
      ),
    );
  }

  Widget txDetail() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24).w,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("asset_trade_detail_fee"),
          (logic.tokenTransaction.value?.gasPrice?.hextobigInt.toGwei.fixed4 ??
                  '')
              .toText
            ..style =
                Styles.ts_333333_14_bold.adapterDark(Styles.ts_CCCCCC_14_bold),
          24.gapv,
          label("asset_trade_detail_receipt"),
          AddressCopy(
            address: logic.tokenTransaction.value!.to.delPad,
            width: 243.w,
          ),
          24.gapv,
          label("asset_trade_detail_block_height"),
          (logic.tokenTransaction.value?.blockNumber.hextobigInt.toString() ??
                  '')
              .toText
            ..style =
                Styles.ts_333333_14_bold.adapterDark(Styles.ts_CCCCCC_14_bold),
          24.gapv,
          label("asset_trade_detail_time"),
          (logic.tokenTransaction.value?.time.hexToDate() ?? '').toText
            ..style =
                Styles.ts_333333_14_bold.adapterDark(Styles.ts_CCCCCC_14_bold),
        ],
      ),
    );
  }

  Widget txBrowserUrl() {
    final url = '$browserTxUrl#${logic.tokenTransaction.value?.from}';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label('URL'),
          Row(
            children: [
              Expanded(
                  child: EllipsizedText(url,
                      style: Styles.ts_999999_14
                          .copyWith(decoration: TextDecoration.underline))),
              2.gaph,
              ButtonCopy(data: url),
              24.gaph
            ],
          ),
          44.gapv,
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28).w,
              child: "asset_trade_detail_button_browser".tr.toButton
                ..variants = ButtonVariants.outline
                ..onPressed = () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    if (Get.context != null) {
                      ToastHelper.showToast(Get.context!,
                          "asset_trade_detail_launchUrl_error".tr);
                    }
                  }
                })
        ],
      ),
    );
  }

  Widget label(String text) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0).w,
        child: text.tr.toText..style = Styles.ts_666666_14_medium);
  }
}
