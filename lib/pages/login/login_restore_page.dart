import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/login/login_logic.dart';

class LoginRestorePage extends StatelessWidget {
  LoginRestorePage({super.key});

  final logic = Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Obx(() => Container(
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 64).w,
          padding: EdgeInsets.only(
              bottom: context.mediaQueryPadding.bottom + 8.w, top: 16.w),
          child: "setting_password_button".tr.toButton
            ..loading = logic.loading.value
            ..onPressed = logic.startRestore)),
      appBar: TitleBar.back(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0).w,
              child: Container(
                padding: const EdgeInsets.only(bottom: 24).w,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color:
                                Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        "sign_restore_title".tr.toText
                          ..style = Styles.ts_333333_24_bold
                              .adapterDark(Styles.ts_CCCCCC_24_bold),
                        12.gapv,
                        "setting_password_desc".tr.toText
                          ..style = Styles.ts_999999_14
                              .adapterDark(Styles.ts_555555_14)
                      ],
                    )),
                    "account_img_regain".png.toImage
                      ..width = 170.w
                      ..fit = BoxFit.cover
                  ],
                ),
              ),
            ),
            32.gapv,
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0).w,
                  child: TextTab(
                      items: logic.restoreTabs
                          .map((tab) => TextTabItem(
                              label: tab.tr,
                              value: logic.restoreTabs.indexOf(tab)))
                          .toList(),
                      activeItem: logic.restoreActiveTab.value,
                      onChanged: (index) {
                        logic.pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut);
                        logic.restoreActiveTab.value = index;
                      }),
                )),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 360.w),
              child: LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  height: constraints.minHeight,
                  child: FormBuilder(
                    key: logic.restoreformKey,
                    child: PageView(
                      controller: logic.pageController,
                      onPageChanged: (value) =>
                          logic.restoreActiveTab.value = value,
                      children: [
                        FormContent(
                          fromKey: logic.restoreTabs[0],
                        ),
                        FormContent(
                          fromKey: logic.restoreTabs[1],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FormContent extends StatelessWidget {
  const FormContent({
    super.key,
    required this.fromKey,
  });

  final String fromKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "sign_restore_tab_${fromKey}_hint".tr.toText
              ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
            12.gapv,
            PasteInput(
              name: fromKey,
              maxLines: 8,
              gapLine: -28.h,
              validator: (val) {
                if (val != null && val.isNotEmpty) {
                  if (fromKey == 'mnemonic') {
                    if (!WalletUtil.validMnemonic(val)) {
                      return "sign_restore_tab_${fromKey}_error".tr;
                    } else {
                      return null;
                    }
                  }

                  if (fromKey == 'privkey') {
                    if (!WalletUtil.validPrivateKey(val)) {
                      return "sign_restore_tab_${fromKey}_error".tr;
                    } else {
                      return null;
                    }
                  }
                }
                return "sign_restore_tab_${fromKey}_error".tr;
              },
            )
          ],
        ));
  }
}
