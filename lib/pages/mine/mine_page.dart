import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'mine_logic.dart';

class MinePage extends StatelessWidget {
  MinePage({super.key});

  final logic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 24.w, top: context.mediaQueryPadding.top, bottom: 10.w),
              child: Stack(
                children: [
                  Row(
                    children: [identityButton(context)],
                  ),
                  Positioned(right: 16, top: -10.w, child: themeButton(context))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget identityButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 24.w,
        padding: const EdgeInsets.only(left: 8, right: 10).w,
        decoration: BoxDecoration(
            color: Styles.c_F3F3F3.adapterDark(Styles.c_222222),
            borderRadius: BorderRadius.circular(30.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "me_ico_identity".svg.toSvg
              ..width = 16.w
              ..height = 16.w
              ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
            3.gaph,
            "me_id_change".tr.toText
              ..style = Styles.ts_333333_12.adapterDark(Styles.ts_CCCCCC_12),
            3.gaph,
            "arrow_down".svg.toSvg
              ..width = 10.w
              ..fit = BoxFit.cover
              ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
          ],
        ),
      ),
    );
  }

  Widget themeButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        final theme = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
        Get.changeThemeMode(theme);
        DataSp.putTheme(theme);
        Get.forceAppUpdate();
      },
      icon: AnimatedCrossFade(
        duration: const Duration(milliseconds: 250),
        firstCurve: Curves.bounceInOut,
        secondCurve: Curves.bounceInOut,
        crossFadeState: Get.isDarkMode
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
  }
}
