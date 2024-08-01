import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/theme_controller.dart';

class SettingThemePage extends StatelessWidget {
  SettingThemePage({super.key});

  final themeLogic = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "setting_theme_title".tr,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24).w,
        child: Obx(() => Column(
              children: ThemeMode.values.map((theme) {
                final isSelected = themeLogic.appTheme.value == theme;
                return GestureDetector(
                  onTap: () {
                    themeLogic.changeTheme(theme);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                    padding: const EdgeInsets.only(
                            left: 16, right: 12, top: 28, bottom: 28)
                        .w,
                    margin: const EdgeInsets.only(bottom: 12).w,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected
                              ? Styles.c_0C8CE9
                              : Styles.c_EDEDED.adapterDark(Styles.c_262626)),
                      color: isSelected
                          ? Styles.c_0C8CE9.withOpacity(0.05)
                          : Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            "nvbar_ico_theme_${theme.name.toLowerCase()}"
                                .svg
                                .toSvg
                              ..width = 24.w
                              ..height = 24.w
                              ..color = isSelected
                                  ? Styles.c_0C8CE9
                                  : Styles.c_333333
                                      .adapterDark(Styles.c_CCCCCC),
                            8.gaph,
                            AnimatedDefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: Styles.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Styles.c_0481DC
                                      : Styles.c_333333
                                          .adapterDark(Styles.c_CCCCCC)),
                              duration: const Duration(milliseconds: 250),
                              child: "setting_theme_${theme.name.toLowerCase()}"
                                  .tr
                                  .toText,
                            ),
                          ],
                        ),
                        isSelected
                            ? ("selected".svg.toSvg
                              ..width = 24.w
                              ..height = 24.w)
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
      ),
    );
  }
}
