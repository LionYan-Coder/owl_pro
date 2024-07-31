import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/mine/qrcode/mine_qrcode_logic.dart';

class MineQrcodePage extends StatelessWidget {
  MineQrcodePage({super.key});

  final logic = Get.find<MineQrcodeLogic>();
  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Styles.c_0C8CE9, Styles.c_FFFFFF],
            stops: [0, 0.95],
            transform: GradientRotation(87 * pi / 2)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TitleBar.back(
          backgroundColor: Colors.transparent,
          backIconColor: Styles.c_FFFFFF,
          title: "share_title".tr,
          titleStyle: Styles.ts_FFFFFF_18_medium,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24).w,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 40).w,
                decoration: BoxDecoration(
                    color: Styles.c_FFFFFF,
                    borderRadius: BorderRadius.circular(12).w,
                    border: Border.all(color: Styles.c_EDEDED)),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                        top: 50.w,
                        left: 0,
                        right: 0,
                        child: "token_placeholder".png.toImage
                          ..width = 158.w
                          ..height = 170.w
                          ..fit = BoxFit.contain),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        shareInfo(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16).w,
                          child: Column(
                            children: [
                              QRcode(
                                  onSave: (fn) {
                                    logic.saveFunction = fn;
                                  },
                                  code: imLogic.userInfo.value.address?.toOc ??
                                      ''),
                              16.gapv,
                              Container(
                                height: 1,
                                color: Styles.c_F6F6F6,
                              ),
                              24.gapv,
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 42)
                                          .w,
                                  child: "share_scan_qrcode".tr.toText
                                    ..textAlign = TextAlign.center
                                    ..style = Styles.ts_0C8CE9_14)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              bottomBtns()
            ],
          ),
        ),
      ),
    );
  }

  Padding shareInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16).w,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          "login_img_logo".png.toImage
            ..width = 68.w
            ..fit = BoxFit.cover,
          12.gapv,
          "sign_guide_title".tr.toText
            ..style = TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF313131).withOpacity(0.7),
                letterSpacing: 5.w),
          "sign_guide_desc".tr.toText..style = Styles.ts_999999_10,
          16.gapv,
          UserAvatar(
              avatar: imLogic.userInfo.value.faceURL,
              radius: 32.w,
              nickname: imLogic.userInfo.value.nickname ?? ''),
          8.gapv,
          (imLogic.userInfo.value.nickname ?? '').toText
            ..style = Styles.ts_333333_20_medium,
          16.gapv,
          (imLogic.userInfo.value.address?.toOc ?? '').toText
            ..style = Styles.ts_666666_14
            ..maxLines = 2
            ..textAlign = TextAlign.center
        ],
      ),
    );
  }

  Padding bottomBtns() {
    return Padding(
      padding: EdgeInsets.only(
          top: 16.0.w, bottom: ScreenUtil().bottomBarHeight + 9.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: logic.save,
            child: Column(
              children: [
                'code_ico_down'.svg.toSvg
                  ..width = 48.w
                  ..height = 48.w,
                8.gapv,
                "share_save".tr.toText..style = Styles.ts_FFFFFF_12
              ],
            ),
          ),
          80.gaph,
          GestureDetector(
            onTap: () {
              logic.share(imLogic.userInfo.value.address?.toOc ?? '');
            },
            child: Column(
              children: [
                'code_ico_share'.svg.toSvg
                  ..width = 48.w
                  ..height = 48.w,
                8.gapv,
                "share_share".tr.toText..style = Styles.ts_FFFFFF_12
              ],
            ),
          )
        ],
      ),
    );
  }
}
