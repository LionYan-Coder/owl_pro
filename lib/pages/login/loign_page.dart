import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/login/login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = logic.wallet.value as Wallet;
    final String privKey = wallet.privKey;
    final String? mnemonic = wallet.mnemonic;
    return Scaffold(
      appBar: TitleBar.back(
        title: "sign_backup_title".tr,
      ),
      body: Column(
        children: [
          8.gapv,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24).w,
            child: Container(
              padding: const EdgeInsets.only(
                      top: 10, bottom: 16, left: 25, right: 25)
                  .w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Styles.c_0C8CE9.withOpacity(0.05),
              ),
              child: "sign_backup_desc".tr.toText
                ..textAlign = TextAlign.center
                ..style = Styles.ts_0C8CE9_14,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24).w,
              child:
                  _copyContent(label: "mnemonic".tr, content: mnemonic ?? '')),
          24.gapv,
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24).w,
              child: _copyContent(label: "privkey".tr, content: privKey)),
          Obx(
            () => Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 24).w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: logic.checked.value,
                            onChanged: (b) {
                              logic.checked.value = b ?? false;
                            }),
                        "sign_backup_check".tr.toText
                          ..style = Styles.ts_333333_14.adapterDark(Styles.ts_999999_14)
                      ],
                    ),
                    Button(
                      onPressed: logic.checked.value ? logic.login : null,
                      text: "sign_backup_button".tr,
                    )
                  ],
                ),
              ),
            ),
          ),
          context.mediaQueryPadding.bottom.gapv
        ],
      ),
    );
  }

  Widget _copyContent({required String label, required String content}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            label.toText
              ..style = Styles.ts_333333_16_medium.adapterDark(Styles.ts_EDEDED_16_medium),
            ButtonCopy(data: content),
          ],
        ),
        12.gapv,
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20).w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Styles.c_F9F9F9.adapterDark(Styles.c_121212),
                border: Border.all(
                    color: Styles.c_EDEDED.adapterDark("#262626".color))),
            child: content.toText
              ..textAlign = TextAlign.center
              ..style = Styles.ts_666666_14)
      ],
    );
  }
}
