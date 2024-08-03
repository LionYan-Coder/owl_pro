import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/pages/transfer/transfer_logic.dart';

class TransferPage extends StatelessWidget {
  TransferPage({super.key});
  final logic = Get.find<TransferLogic>();
  final mineLogic = Get.find<MineLogic>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: bottom(context),
          appBar: TitleBar.back(
            title: "send_coin_title".tr,
          ),
          body: SingleChildScrollView(
            child: FormBuilder(
              key: logic.formKey,
              onChanged: logic.onChangeForm,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24)
                        .w,
                child: Column(
                  children: [
                    selectCoin(),
                    receiptAddress(),
                    sendNum(),
                    maxFree()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Container bottom(BuildContext context) {
    return Container(
        width: 1.sw,
        padding: EdgeInsets.only(
            left: 64.w,
            right: 64.w,
            top: 16.w,
            bottom: context.mediaQueryPadding.bottom + 10.w),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Styles.c_F6F6F6.adapterDark(Styles.c_161616))),
            color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D)),
        child: "send_coin_button".tr.toButton..onPressed = logic.onSubmit);
  }

  Widget selectCoin() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15).w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          label("send_coin_type_label"),
          Builder(builder: (context) {
            return GestureDetector(
              onTap: logic.showSelectTokenSheet,
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                        color: Styles.c_F9F9F9,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: Styles.c_EDEDED)),
                    child: Center(
                      child: logic.tokenType.value.name.png.toImage
                        ..width = 24.w
                        ..fit = BoxFit.cover,
                    ),
                  ),
                  4.gaph,
                  logic.tokenType.value.name.toUpperCase().toText
                    ..style = Styles.ts_0C8CE9_16_bold,
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  Widget maxFree() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24).w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("send_coin_free_label"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              "${logic.maxFee.value.fixed6} ${logic.tokenType.value.name.toUpperCase()}"
                  .toText
                ..style = Styles.ts_0C8CE9_14_medium,
              "≈\$${logic.maxFee.value.owlToUsd.fixed4}".toText
                ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12)
            ],
          )
        ],
      ),
    );
  }

  Widget sendNum() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24).w,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("send_coin_num_label"),
          12.gapv,
          Input(
              name: "send_num",
              inputType: InputType2.number,
              style: Styles.ts_333333_28_bold
                  .adapterDark(Styles.ts_CCCCCC_28_bold),
              contentPadding: EdgeInsets.only(
                  top: 24.w, bottom: 24.w, left: 16.w, right: 12.w),
              suffix: logic.tokenType.value.name.toUpperCase().toText
                ..style = Styles.ts_0C8CE9_16_bold),
          12.gapv,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      text: "balance".tr,
                      style:
                          Styles.ts_999999_14.adapterDark(Styles.ts_555555_14),
                      children: [
                    TextSpan(
                        text: logic.balance.toWei.toString(),
                        style: Styles.ts_0C8CE9_14)
                  ])),
              TextButton(
                onPressed: logic.onTapAll,
                child: "all".tr.toText..style = Styles.ts_0C8CE9_14,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget receiptAddress() {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              label("send_coin_receipt_label"),
              IconButton(
                onPressed: () {
                  //TODO 跳转到扫描二维码页面
                },
                icon: "ico_scan".svg.toSvg
                  ..width = 24.w
                  ..height = 24.w
                  ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
              )
            ],
          ),
          8.gapv,
          PasteInput(
            name: "receipt_address",
            maxLines: 3,
            gapLine: 6.h,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: "send_coin_receipt_empty_error".tr),
              (val) {
                if (val != null) {
                  if (val.startsWith("oc") &&
                      WalletUtil.validAdress(val.to0x)) {
                    return null;
                  } else {
                    return "send_coin_receipt_error".tr;
                  }
                }

                return "send_coin_receipt_empty_error".tr;
              }
            ]),
          ),
        ],
      ),
    );
  }

  Widget label(String text) {
    return text.tr.toText
      ..style =
          Styles.ts_333333_16_medium.adapterDark(Styles.ts_CCCCCC_16_medium);
  }
}
