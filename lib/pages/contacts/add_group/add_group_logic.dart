import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/conversation/conversation_logic.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class AddGroupLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  final formKey = GlobalKey<FormBuilderState>();
  final tagFormKey = GlobalKey<FormBuilderState>();

  final tags = <String>[].obs;
  final needVerification = 1.obs;
  final faceURL = ''.obs;

  void selectAvatar() {
    IMViews.openPhotoSheet(onData: (path, url) {
      if (url != null) faceURL.value = url;
    });
  }

  void onChangeVerification(int n) {
    needVerification.value = n;
  }

  void onCloseTag(String tag) {
    tags.remove(tag);
  }

  completeCreation() async {
    final state = formKey.currentState;
    final valid = state?.saveAndValidate(focusOnInvalid: false);
    if (valid == true) {
      final groupName = state?.getRawValue("groupName");
      final introduction = state?.getRawValue("introduction");

      var info = await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.groupManager.createGroup(
            groupInfo: GroupInfo(
                groupID: '',
                groupName: groupName,
                faceURL: faceURL.value,
                groupType: GroupType.work,
                introduction: introduction,
                needVerification: needVerification.value,
                ex: tags.join('#')),
            ownerUserID: OpenIM.iMManager.userID),
      );

      conversationLogic.toChat(
        offUntilHome: true,
        groupID: info.groupID,
        nickname: groupName,
        faceURL: faceURL.value,
        sessionType: info.sessionType,
      );
    }
  }

  void showTagInputDialog() async {
    final b = await Get.dialog<bool>(
      AlertDialog(
        insetPadding: const EdgeInsets.all(24).w,
        titlePadding: const EdgeInsets.only(left: 24, right: 24).w,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32).w,
              child: "add_group_tag_input_title".tr.toText
                ..style = Styles.ts_333333_18_bold
                    .adapterDark(Styles.ts_CCCCCC_18_bold),
            ),
            GestureDetector(
              onTap: () {
                Get.back(result: false);
              },
              child: "close".svg.toSvg
                ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
            )
          ],
        ),
        backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        content: SizedBox(
          width: 0.85.sw,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              18.gapv,
              FormBuilder(
                  key: tagFormKey,
                  child: Input(
                    name: "tag",
                    hintText: "add_group_tag_input_error1".tr,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "add_group_tag_input_error2".tr),
                      FormBuilderValidators.maxLength(8,
                          errorText: "add_group_tag_input_error1".tr)
                    ]),
                  )),
              28.gapv,
              Padding(
                padding: const EdgeInsets.only(bottom: 8).w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                        child: "cancel".tr.toButton
                          ..variants = ButtonVariants.outline
                          ..onPressed = () => Get.back(result: false)),
                    8.gaph,
                    Flexible(
                        child: "save".tr.toButton
                          ..onPressed = () {
                            final valid = tagFormKey.currentState
                                ?.saveAndValidate(focusOnInvalid: false);

                            if (valid == true) {
                              Get.back(result: true);
                            }
                          }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    if (b == true) {
      final tag = tagFormKey.currentState?.getRawValue("tag") as String;
      if (tag.isNotEmpty) {
        tags.add(tag);
      }
    }
  }
}
