import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/guide/guide_logic.dart';
import 'package:owlpro_app/pages/guide/widgets/guide_dot.dart';
import 'package:owlpro_app/pages/guide/widgets/guide_first.dart';
import 'package:owlpro_app/pages/guide/widgets/guide_three.dart';
import 'package:owlpro_app/pages/guide/widgets/guide_two.dart';
import 'package:owlpro_app/widgets/five_corners_clipper.dart';

class GuidePage extends StatelessWidget {
  GuidePage({super.key});

  final guideLogic = Get.find<GuideLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_121212),
      body: GestureDetector(
        onPanUpdate: guideLogic.onPanUpdate,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: ClipRect(
            child: Stack(
              children: [
                ClipPath(
                  clipper: FiveCornersClipper(),
                  child: Container(
                    height: 0.6.sh,
                    color: Styles.c_F9F9F9.adapterDark(Styles.c_0D0D0D),
                  ),
                ),
                GuideFirst(animationController: guideLogic.animationController),
                GuideTwo(animationController: guideLogic.animationController),
                GuideThree(animationController: guideLogic.animationController),
                GuideDot(
                  animationController: guideLogic.animationController,
                ),
                Positioned(
                    bottom: ScreenUtil().bottomBarHeight + 32,
                    child: Container(
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(horizontal: 64.w),
                      child: "guide_button_text".tr.toButton
                        ..onPressed = guideLogic.startLogin,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
