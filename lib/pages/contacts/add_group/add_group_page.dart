import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

import 'add_group_logic.dart';

class AddGroupPage extends StatelessWidget {
  final logic = Get.find<AddGroupLogic>();
  AddGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: "add_group_title".tr,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                32.gapv,
                Center(
                  child: logic.faceURL.isNotEmpty
                      ? AvatarView(
                          radius: 36.r,
                          url: logic.faceURL.value,
                          onTap: logic.selectAvatar,
                        )
                      : ClipOval(
                          child: Button(
                            width: 72.w,
                            height: 72.w,
                            onPressed: logic.selectAvatar,
                            child: Center(
                              child: "tool_ico_add".svg.toSvg
                                ..color = Styles.c_FFFFFF,
                            ),
                          ),
                        ),
                ),
                14.gaph,
                FormBuilder(
                    key: logic.formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: 26, horizontal: 24)
                          .w,
                      child: Column(
                        children: [
                          Input(
                            name: "groupName",
                            inputType: InputType2.name,
                            hintText: "add_group_name_hint".tr,
                            validator: FormBuilderValidators.required(
                                errorText: "add_group_name_error".tr),
                          ),
                          16.gapv,
                          Input(
                            name: "introduction",
                            inputType: InputType2.name,
                            hintText: "add_group_desc_hint".tr,
                            maxLines: 5,
                            validator: FormBuilderValidators.maxLength(100,
                                errorText: "add_group_desc_error".tr),
                          )
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 16).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label(label: "add_group_tag_title".tr),
                          IconButton(
                              onPressed: logic.tags.length >= 5
                                  ? null
                                  : logic.showTagInputDialog,
                              icon: "nvbar_ico_add".svg.toSvg
                                ..width = 24.w
                                ..height = 24.w
                                ..color = Styles.c_333333
                                    .adapterDark(Styles.c_CCCCCC))
                        ],
                      ),
                      "add_group_tag_hint".tr.toText
                        ..style = Styles.ts_999999_12
                            .adapterDark(Styles.ts_666666_12),
                      18.gapv,
                      Obx(() => Wrap(
                            runSpacing: 8.w,
                            children: logic.tags
                                .map((tag) => Container(
                                      margin:
                                          const EdgeInsets.only(right: 8.0).w,
                                      child: Tag(
                                          label: tag,
                                          onDismissed: () =>
                                              logic.onCloseTag(tag)),
                                    ))
                                .toList(),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _label(label: "add_group_apply_title".tr),
                      Switch(
                          value: logic.needVerification.value == 1,
                          onChanged: (v) =>
                              logic.onChangeVerification(v ? 1 : 2))
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.w),
            child: "add_group_button".tr.toButton
              ..onPressed = logic.completeCreation,
          ),
        ));
  }

  Widget _label({required String label}) {
    return label.toText
      ..style =
          Styles.ts_333333_16_medium.adapterDark(Styles.ts_CCCCCC_16_medium);
  }
}
