import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class AuthDialog {
  static Future<String> showSetPassworddDialog() async {
    final formKey = GlobalKey<FormBuilderState>();

    void submit() {
      var valid = formKey.currentState?.saveAndValidate(focusOnInvalid: false);
      if (valid != null && valid) {
        var pwd = formKey.currentState?.getRawValue("password");
        Get.back(result: pwd);
      }
    }

    final b = await Get.dialog<String>(
      AlertDialog(
        insetPadding: const EdgeInsets.all(24).w,
        titlePadding: const EdgeInsets.only(top: 32, left: 24, right: 24).w,
        title: "sign_dialog_title".tr.toText
          ..style =
              Styles.ts_333333_18_bold.adapterDark(Styles.ts_CCCCCC_18_bold),
        backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0.r))),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8).w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Styles.c_0C8CE9.withOpacity(0.05),
                ),
                child: "sign_dialog_desc".tr.toText
                  ..style = Styles.ts_0C8CE9_14,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 12).w,
                child: "sign_dialog_password_label".tr.toText
                  ..style =
                      Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
              ),
              FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    Input(
                        name: 'password',
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
                              formKey.currentState?.getRawValue("password");
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
              ),
              32.gapv,
              "confirm".tr.toButton..onPressed = submit
            ],
          ),
        ),
      ),
      barrierDismissible: false, // user must tap button!
    );

    return b ?? '';
  }

  static Future<bool> showVerifyPasswordDialog({
    required String password,
    bool close = false,
  }) async {
    final formKey = GlobalKey<FormBuilderState>();

    void submit() {
      var valid = formKey.currentState?.saveAndValidate(focusOnInvalid: false);
      if (valid != null && valid) {
        Get.back(result: true);
      }
    }

    final b = await Get.dialog<bool>(
      AlertDialog(
        insetPadding: const EdgeInsets.all(24).w,
        titlePadding: const EdgeInsets.only(left: 24, right: 24).w,
        backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32).w,
              child: "sign_verifypwd_dialog_title".tr.toText
                ..style = Styles.ts_333333_18_bold
                    .adapterDark(Styles.ts_CCCCCC_18_bold),
            ),
            close
                ? Padding(
                    padding: const EdgeInsets.only(top: 16).w,
                    child: IconButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      icon: "close".svg.toSvg
                        ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 0.85.sw,
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      Input(
                          name: 'password',
                          inputType: InputType2.password,
                          hintText: "sign_verifypwd_dialog_title".tr,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.minLength(6,
                                errorText: "sign_dialog_password_error".tr),
                            (val) {
                              Logger.print(
                                  "passwprd $password ${EncryptionHelper.decrypt64(password)} $val");
                              if (val != null &&
                                  val.isNotEmpty &&
                                  EncryptionHelper.encrypted64(val) !=
                                      password) {
                                return "sign_dialog_password_invalid_error".tr;
                              }

                              return null;
                            }
                          ])),
                    ],
                  ),
                ),
                32.gapv,
                "confirm".tr.toButton..onPressed = submit
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // user must tap button!
    );

    return b == true;
  }
}

class WillPopDialog {
  static Future<bool> showConfirmDialog() async {
    final pop = await Get.dialog<bool>(
      AlertDialog(
        insetPadding: const EdgeInsets.all(24).w,
        titlePadding: const EdgeInsets.only(top: 32, left: 24, right: 24).w,
        title: "will_pop_dialog_title".tr.toText
          ..style =
              Styles.ts_333333_18_bold.adapterDark(Styles.ts_CCCCCC_18_bold),
        backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 0.85.sw,
            child: LayoutBuilder(builder: (context, contains) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16).w,
                      child: "will_pop_dialog_content".tr.toText
                        ..style = Styles.ts_333333_16
                            .adapterDark(Styles.ts_CCCCCC_16)),
                  28.gapv,
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, right: 14, bottom: 8).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                            child: "will_pop_dialog_button_cancel".tr.toButton
                              ..variants = ButtonVariants.outline
                              ..onPressed = () => Get.back(result: false)),
                        8.gaph,
                        Flexible(
                            child: "will_pop_dialog_button_save".tr.toButton
                              ..onPressed = () => Get.back(result: true)),
                      ],
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
      barrierDismissible: false,
    ); // user must tap button!

    return pop == true;
  }
}
