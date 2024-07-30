import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/login/login_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';
import 'package:owlpro_app/widgets/five_corners_clipper.dart';
import 'package:owlpro_app/widgets/locale_select.dart';

class LoginReadyPage extends StatelessWidget {
  LoginReadyPage({super.key});

  final logic = Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_121212),
      body: Padding(
        padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
        child: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                Positioned.fill(
                    child: ClipPath(
                  clipper: FiveCornersClipper(),
                  child: Container(
                    padding: EdgeInsets.only(top: 50.w + 36.w),
                    color: Styles.c_F9F9F9.adapterDark(Styles.c_0D0D0D),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "login_img_chat".png.toImage
                          ..width = 240.w
                          ..height = 240.w,
                        36.gapv,
                        "login_img_logo".png.toImage
                          ..width = 152.w
                          ..fit = BoxFit.cover
                          ..adpaterDark = true,
                        21.gapv,
                        "sign_guide_title".tr.toText
                          ..style = Styles.ts_666666_24_medium
                              .adapterDark(Styles.ts_999999_24_medium)
                              .copyWith(letterSpacing: 5),
                        4.gapv,
                        "sign_guide_desc".tr.toText
                          ..style = Styles.ts_999999_10
                              .adapterDark(Styles.ts_555555_10)
                      ],
                    ),
                  ),
                )),
                Positioned(
                    right: 28.w,
                    top: 8.w + context.mediaQueryPadding.top,
                    child: const LocaleSelect())
              ],
            )),
            36.gapv,
            Padding(
              padding: const EdgeInsets.only(bottom: 54, left: 64, right: 64).w,
              child: Column(
                children: [
                  Button(
                      height: 56.w,
                      onPressed: () {
                        logic.createWallet();
                        AppNavigator.startLoginCreate();
                        // context.push(AppRouter.signCreatePath);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "sign_guide_create_title".tr.toText
                            ..style = Styles.ts_FFFFFF_18_medium,
                          "sign_guide_create_text".tr.toText
                            ..style = Styles.ts_FFFFFF_10_medium.copyWith(
                                color: Styles.c_FFFFFF.withOpacity(0.7))
                        ],
                      )),
                  20.gapv,
                  Button(
                      height: 56.w,
                      onPressed: () {
                        // context.push(AppRouter.signCreatePath);
                      },
                      variants: ButtonVariants.outline,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "sign_guide_restore_title".tr.toText
                            ..style = Styles.ts_333333_18_medium
                                .adapterDark(Styles.ts_CCCCCC_18_medium),
                          "sign_guide_restore_text".tr.toText
                            ..style = Styles.ts_CCCCCC_10_medium.copyWith(
                                color: Styles.c_999999.withOpacity(0.7))
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
