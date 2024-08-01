import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class SettingMenu extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget? extra;
  final Widget? hint;
  const SettingMenu(
      {super.key, required this.label, this.extra, this.hint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12).w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                label.toText
                  ..style = Styles.ts_333333_16
                      .adapterDark(Styles.ts_CCCCCC_16)
                      .copyWith(letterSpacing: 1.w),
                Row(
                  children: [
                    extra ?? const SizedBox.shrink(),
                    "arrow_right".svg.toSvg
                      ..width = 16.w
                      ..fit = BoxFit.cover
                      ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                  ],
                )
              ],
            ),
          ),
        ),
        hint ?? const SizedBox.shrink()
      ],
    );
  }
}
