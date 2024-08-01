import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/user_profile/user_profile_logic.dart';

class AddFriendDialog extends StatelessWidget {
  final UserFullInfo user;
  AddFriendDialog({super.key, required this.user});

  final logic = Get.find<UserProfileLogic>(tag: GetTags.userProfile);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Stack(
            fit: StackFit.loose,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r)),
                child: FormBuilder(
                  initialValue: const {"reason": "", "userRemarkName": ""},
                  key: logic.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.gapv,
                      "user_search_result_dialog_apply_title".tr.toText
                        ..style = Styles.ts_333333_18_bold
                            .adapterDark(Styles.ts_CCCCCC_18_bold),
                      12.gapv,
                      Input(
                        name: "reason",
                        maxLines: 6,
                        hintText: "user_search_result_dialog_apply_hint".tr,
                      ),
                      16.gapv,
                      "user_search_result_dialog_remark_title".tr.toText
                        ..style = Styles.ts_333333_18_bold
                            .adapterDark(Styles.ts_CCCCCC_18_bold),
                      12.gapv,
                      Input(
                        name: "remark",
                        hintText: "user_search_result_dialog_remark_hint".tr,
                      ),
                      24.gapv,
                      "user_search_result_dialog_button".tr.toButton
                        ..onPressed = () {
                          final valid = logic.formKey.currentState
                              ?.saveAndValidate(focusOnInvalid: false);

                          if (valid == true) {
                            Get.back(result: valid);
                          }
                        },
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 8.w,
                  right: 8.w,
                  child: IconButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    icon: "close".svg.toSvg
                      ..width = 24.w
                      ..height = 24.w
                      ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

//  ToastHelper.showToast(
//                                   context,
//                                   context
//                                       .tr("user_search_result_dialog_success"))