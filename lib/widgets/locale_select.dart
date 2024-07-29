import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class LocaleSelect extends StatelessWidget {
  const LocaleSelect({super.key});

  bool _isSelected(BuildContext context, String lang) {
    Locale? locale = Get.locale;
    if (locale != null) {
      final locales = locale.toLanguageTag().split("-");
      final langs = lang.split("_");
      return locales.contains(langs[0]) && locales.contains(langs[1]);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale as Locale;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
          dropdownStyleData: DropdownStyleData(
              offset: Offset(0.w, -4.w),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6).w,
              decoration: BoxDecoration(
                color: Styles.c_F3F3F3.adapterDark(Styles.c_222222),
                borderRadius: BorderRadius.circular(8.r),
              )),
          menuItemStyleData: MenuItemStyleData(
            height: 36.w,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6).w,
          ),
          onChanged: (val) {
            final vals = val?.split("_") as List;
            Get.updateLocale(Locale(vals[0], vals[1]));
          },
          customButton: AbsorbPointer(
            child: Button(
                block: false,
                onPressed: () {},
                variants: ButtonVariants.custom,
                color: Styles.c_F3F3F3.adapterDark(Styles.c_222222),
                pressColor: Styles.c_EDEDED.adapterDark(Styles.c_1B1B1B),
                height: 24.w,
                borderRadius: 30.r,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 10).w,
                  child: Row(
                    children: [
                      trMap["${locale.languageCode}_${locale.countryCode ?? ''}"]!
                          .toText
                        ..style = Styles.ts_333333_12
                            .adapterDark(Styles.ts_CCCCCC_12),
                      4.gaph,
                      "arrow_down".svg.toSvg
                        ..width = 10.w
                        ..height = 10.w
                        ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)
                    ],
                  ),
                )),
          ),
          items: Get.translations.keys
              .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(
                      trMap[lang] ?? '',
                      style: _isSelected(context, lang)
                          ? Styles.ts_0C8CE9_12
                          : Styles.ts_333333_12
                              .adapterDark(Styles.ts_CCCCCC_12),
                    ),
                  ))
              .toList()),
    );
  }
}
