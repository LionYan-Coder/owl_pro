import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class SettingLanguagePage extends StatelessWidget {
  const SettingLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale;
    return Scaffold(
      appBar: TitleBar.back(
        title: "setting_lang_title".tr,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24).w,
        child: Column(
          children: Get.translations.keys.map((lang) {
            final isSelected = _isSelected(lang, locale);
            return GestureDetector(
              onTap: () {
                final vals = lang.split("_") as List;
                Get.updateLocale(Locale(vals[0], vals[1]));
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
                        "language_icn_${lang.split("_")[0].toLowerCase()}"
                            .svg
                            .toSvg
                          ..width = 24.w
                          ..height = 24.w
                          ..color = isSelected
                              ? Styles.c_0C8CE9
                              : Styles.c_333333.adapterDark(Styles.c_CCCCCC),
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
                          child: (trMap[lang] ?? '').toText,
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
        ),
      ),
    );
  }

  bool _isSelected(String lang, Locale? locale) {
    if (locale != null) {
      final locales = locale.toLanguageTag().split("-");
      final langs = lang.split("_");
      return locales.contains(langs[0]) && locales.contains(langs[1]);
    }

    return false;
  }
}
