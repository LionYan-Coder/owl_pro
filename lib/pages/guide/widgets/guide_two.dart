import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class GuideTwo extends StatelessWidget {
  final AnimationController animationController;
  const GuideTwo({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final enterAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final leaveAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.2,
          0.4,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    return SlideTransition(
      position: enterAnimation,
      child: SlideTransition(
          position: leaveAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: ScreenUtil().statusBarHeight + 70.h),
                child: "launchimage_img_two".png.toImage
                  ..width = 270.w
                  ..height = 270.w,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: ScreenUtil().bottomBarHeight + 190.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Column(
                    children: [
                      "guide_two_title".tr.toText
                        ..style = Styles.ts_333333_24_bold
                            .adapterDark(Styles.ts_CCCCCC_24_bold).copyWith(letterSpacing: 5.w),
                      12.gapv,
                      "guide_two_text".tr.toText
                        ..textAlign = TextAlign.center
                        ..style =
                            Styles.ts_999999_14.adapterDark(Styles.ts_777777_14)
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
