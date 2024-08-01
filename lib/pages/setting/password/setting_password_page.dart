import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/pages/setting/password/setting_password_logic.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SettingPasswordPage extends StatelessWidget {
  SettingPasswordPage({super.key});

  final logic = Get.find<SettingPasswordLogic>();
  final mineLogic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          color: Colors.transparent,
          padding:
              EdgeInsets.only(bottom: context.mediaQueryPadding.bottom, top: 16)
                  .w,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64).w,
              child: "setting_password_button".tr.toButton
                ..onPressed = logic.submit)),
      appBar: TitleBar.back(),
      body: Obx(() => SingleChildScrollView(
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
                                color: Styles.c_F6F6F6
                                    .adapterDark(Styles.c_161616)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            "setting_password_title".tr.toText
                              ..style = Styles.ts_333333_24_bold
                                  .adapterDark(Styles.ts_CCCCCC_24_bold),
                            12.gapv,
                            "setting_password_desc".tr.toText
                              ..style = Styles.ts_999999_14
                                  .adapterDark(Styles.ts_555555_14)
                          ],
                        )),
                        "safe_img_password_small".png.toImage
                          ..width = 170.w
                          ..fit = BoxFit.cover
                      ],
                    ),
                  ),
                ),
                32.gapv,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0).w,
                  child: TextTab(
                      items: logic.tabList
                          .map((tab) => TextTabItem(
                              label: tab.tr, value: logic.tabList.indexOf(tab)))
                          .toList(),
                      activeItem: logic.activeTab.value,
                      onChanged: (index) {
                        logic.pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut);
                        logic.onChangedTab(index);
                      }),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 1.sh - 300.w),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.minHeight,
                      child: PageView(
                          onPageChanged: logic.onChangedTab,
                          controller: logic.pageController,
                          children: [
                            formWrapper(
                                key: logic.formByOldPwd,
                                child: Column(
                                  children: [
                                    byOldPwdFiled(),
                                    setNewPassword(logic.formByOldPwd)
                                  ],
                                )),
                            formWrapper(
                                key: logic.formByPrivKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    byPrivKey(
                                        mineLogic.currentWallet.value.privKey),
                                    setNewPassword(logic.formByPrivKey)
                                  ],
                                )),
                            formWrapper(
                                key: logic.formByMnemonic,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    byMnemonic(mineLogic
                                            .currentWallet.value.mnemonic ??
                                        ''),
                                    setNewPassword(logic.formByMnemonic)
                                  ],
                                ))
                          ]),
                    );
                  }),
                )
              ],
            ),
          )),
    );
  }

  Widget formWrapper(
      {required GlobalKey<FormBuilderState> key, required Widget child}) {
    return FormBuilder(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).w,
          child: child,
        ));
  }

  Widget byOldPwdFiled() {
    return Padding(
      padding: const EdgeInsets.only(top: 8).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "setting_password_oldpwd_hint".tr.toText
            ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
          12.gapv,
          Input(
              name: "old_password",
              hintText: "setting_password_oldpwd_placeholder".tr,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.minLength(6,
                    errorText: "sign_dialog_password_error".tr),
                (val) {
                  if (val != null &&
                      val.isNotEmpty &&
                      val !=
                          EncryptionHelper.decrypt64(
                              mineLogic.currentPassword)) {
                    return "sign_dialog_password_invalid_error".tr;
                  }

                  return null;
                }
              ]))
        ],
      ),
    );
  }

  Widget byPrivKey(String privKey) {
    return Padding(
      padding: const EdgeInsets.only(top: 8).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "setting_password_by_privkey_hint".tr.toText
            ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
          12.gapv,
          PasteInput(
              name: "privkey",
              maxLines: 4,
              validator: (val) {
                if (val != null && val.isNotEmpty) {
                  if (!WalletUtil.validPrivateKey(val)) {
                    return "setting_password_by_privkey_error".tr;
                  } else if (val != privKey) {
                    return "setting_password_by_privkey_error".tr;
                  } else {
                    return null;
                  }
                }
                return "setting_password_by_privkey_error".tr;
              })
        ],
      ),
    );
  }

  Widget byMnemonic(String mnemonic) {
    return Padding(
      padding: const EdgeInsets.only(top: 8).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "setting_password_by_mnemonic_hint".tr.toText
            ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
          12.gapv,
          PasteInput(
              name: "mnemonic",
              maxLines: 4,
              validator: (val) {
                if (val != null && val.isNotEmpty) {
                  if (!WalletUtil.validPrivateKey(val)) {
                    return "setting_password_by_mnemonic_error".tr;
                  } else if (val != mnemonic) {
                    return "setting_password_by_mnemonic_error".tr;
                  } else {
                    return null;
                  }
                }
                return "setting_password_by_mnemonic_error".tr;
              })
        ],
      ),
    );
  }

  Widget setNewPassword(GlobalKey<FormBuilderState> key) {
    return Padding(
      padding: const EdgeInsets.only(top: 32).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "setting_password_new_password_title".tr.toText
            ..style =
                Styles.ts_333333_16_bold.adapterDark(Styles.ts_CCCCCC_16_bold),
          8.gapv,
          "sign_dialog_password_label".tr.toText
            ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
          16.gapv,
          Input(
              name: 'new_password',
              inputType: InputType2.password,
              hintText: "sign_dialog_password_hint".tr,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.minLength(6,
                    errorText: "sign_dialog_password_error".tr),
              ])),
          20.gapv,
          Input(
              name: 'confirm_password',
              inputType: InputType2.password,
              hintText: "sign_dialog_confirmpassword_hint".tr,
              validator: (val) {
                final String? pwd =
                    key.currentState?.getRawValue("new_password");
                if (pwd != null && pwd.isNotEmpty) {
                  if (pwd != val) {
                    return "sign_dialog_confirmpassword_error".tr;
                  } else {
                    return null;
                  }
                }
                return "sign_dialog_confirmpassword_error".tr;
              })
        ],
      ),
    );
  }
}
