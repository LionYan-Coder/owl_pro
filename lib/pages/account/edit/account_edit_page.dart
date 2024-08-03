import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/account/edit/account_edit_logic.dart';
import 'package:owlpro_app/widgets/dialog.dart';

class AccountEditPage extends StatelessWidget {
  AccountEditPage({super.key});

  final logic = Get.find<AccountEditLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userInfo = logic.userInfo.value;
      return Scaffold(
        appBar: TitleBar.back(
          onTap: () async {
            if (logic.isChange) {
              final b = await WillPopDialog.showConfirmDialog();
              if (!b) {
                Get.back();
              }
              if (b) {
                logic.submit();
              }
            }
          },
          title: "identity_edit_title".tr,
          right: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedCrossFade(
                      alignment: Alignment.center,
                      firstChild: IconButton(
                          onPressed: () async {
                            logic.submit();
                          },
                          icon: "nvbar_submit".svg.toSvg
                            ..width = 24.w
                            ..height = 24.w),
                      secondChild: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child:
                            Center(child: CircularProgressIndicator.adaptive()),
                      ),
                      crossFadeState: logic.loading.value
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250)),
                ],
              ),
              16.gaph
            ],
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24).w,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
              child: FormBuilder(
                key: logic.formKey,
                initialValue: {
                  "nickname": userInfo.nickname,
                  "about": userInfo.about,
                  "account": userInfo.account,
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label("identity_edit_cover_label".tr),
                    hint("identity_edit_cover_hint".tr),
                    GestureDetector(
                      onTap: () {
                        logic.openPhotoSheet('coverURL');
                      },
                      child: userCover(),
                    ),
                    24.gapv,
                    label("identity_edit_avatar_label".tr),
                    hint("identity_edit_avatar_hint".tr),
                    AvatarView(
                      onTap: () {
                        logic.openPhotoSheet('faceURL');
                      },
                      radius: 36.w,
                      tag: userInfo.nickname ?? 'avatar',
                      url: logic.avatarUrl.value.isNotEmpty
                          ? logic.avatarUrl.value
                          : userInfo.faceURL,
                      text: userInfo.nickname ?? '',
                    ),
                    24.gapv,
                    label("identity_edit_nickname_label".tr),
                    hint("identity_edit_nickname_hint".tr),
                    Input(
                        name: "nickname",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText:
                                  "identity_edit_nickname_hint".tr), // 必须输入
                          FormBuilderValidators.minLength(4,
                              errorText: "identity_edit_nickname_hint".tr),
                          FormBuilderValidators.maxLength(16,
                              errorText: "identity_edit_nickname_hint".tr),
                        ])),
                    24.gapv,
                    label("identity_edit_about_label".tr),
                    hint("identity_edit_about_hint".tr),
                    const Input(
                      name: "about",
                      maxLines: 4,
                    ),
                    24.gapv,
                    label("identity_edit_account_label".tr),
                    hint("identity_edit_account_hint".tr,
                        warning: "identity_edit_account_warning".tr),
                    Input(
                      name: "account",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "identity_edit_account_hint".tr), // 必须输入
                        FormBuilderValidators.minLength(4,
                            errorText: "identity_edit_account_hint".tr),
                        FormBuilderValidators.maxLength(16,
                            errorText: "identity_edit_account_hint".tr),
                        FormBuilderValidators.match(
                          RegExp(r'^[a-zA-Z0-9]+$'), // 仅支持英文和数字
                          errorText: "identity_edit_account_hint".tr,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            )),
      );
    });
  }

  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0).w,
      child: text.toText
        ..style =
            Styles.ts_333333_16_medium.adapterDark(Styles.ts_CCCCCC_16_medium),
    );
  }

  Widget hint(String text, {String? warning}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0).w,
      child: Row(
        children: [
          warning != null && warning.isNotEmpty
              ? (warning.toText..style = Styles.ts_0C8CE9_12)
              : const SizedBox.shrink(),
          text.toText
            ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12)
        ],
      ),
    );
  }

  Widget userCover() {
    String url = "";
    if (logic.coverUrl.value.isNotEmpty) {
      url = logic.coverUrl.value;
    } else if (logic.coverUrl.value.isNotEmpty) {
      url = logic.userInfo.value.coverURL ?? '';
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(12.0.w),
        child: url.isNotEmpty
            ? Image.network(
                url,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                height: 140.w,
              )
            : ("banner_placeholder".png.toImage
              ..width = double.infinity
              ..height = 140.w
              ..fit = BoxFit.fitWidth));
  }
}
