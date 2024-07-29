import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/splash/splash_logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.find<SplashLogic>();
  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "logo".png.toImage
              ..width = 96.w
              ..height = 96.w,
            32.gapv,
            "login_img_logo".png.toImage
              ..width = 124.w
              ..fit = BoxFit.cover
              ..adpaterDark = true,
            16.gapv,
            "sign_guide_title".tr.toText
              ..style = Styles.ts_666666_20_medium
                  .adapterDark(Styles.ts_999999_20_medium),
            3.gapv,
            "sign_guide_desc".tr.toText
              ..style = Styles.ts_999999_10.adapterDark(Styles.ts_555555_10)
          ],
        ),
      ),
    );
  }
}
