import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/theme_controller.dart';

class ThemeChangeButton extends StatelessWidget {
  const ThemeChangeButton({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ThemeController(),
        builder: (theme) {
          return GestureDetector(
            onTap: () {
              ThemeController.to.toggleTheme();
            },
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 150),
              firstCurve: Curves.fastOutSlowIn,
              secondCurve: Curves.fastOutSlowIn,
              crossFadeState: theme.appTheme == ThemeMode.dark
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: 'ico_theme_light'.svg.toSvg
                ..width = 24.w
                ..height = 24.w
                ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
              secondChild: 'ico_theme_dark'.svg.toSvg
                ..width = 24.w
                ..height = 24.w
                ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
            ),
          );
        });
  }
}
