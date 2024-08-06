import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

import 'widgets/ripple_effect_button.dart';

class LiveRoomPage extends StatelessWidget {
  const LiveRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        // alignment: Alignment.center,
        children: [
          Container(
            color: Colors.transparent,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
            child: Container(
              color: Color.fromRGBO(240, 249, 255, 0.6).adapterDark(Color.fromRGBO(13, 13, 13, 0.6)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0C8CE9),
                  Color(0xFF427BA5),
                  Color(0xFF274B65),
                  Color(0xFF5486AC),
                  Color(0xFF3B86BD),
                  Color(0xFFFFFFFF),
                ],
              ),
              borderRadius: BorderRadius.circular(80.r), // 可以调整边角圆滑度
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 72.h,
            child: Container(
              width: 1.sw,
              margin: EdgeInsets.only(top: 72.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RippleEffectButton(),
                  48.gapv,
                  "chat_live_title".tr.toText..style = Styles.ts_FFFFFF_20_medium,
                  8.gapv,
                  Container(
                    constraints: BoxConstraints(maxWidth: 96.w),
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Styles.c_0C8CE9.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15.r)
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "videocall_ico_request".svg.toSvg..width = 14.w..height = 14.w,
                          4.gaph,
                          "chat_live_hint".tr.toText..style = Styles.ts_0C8CE9_12
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: const EdgeInsets.only(left: 16,top: 2).w,
                child: IconButton(onPressed: (){
                  Get.snackbar("Warning","Floating Window is not yet open");
                }, icon: "nvbar_ico_shrink_black".svg.toSvg..width = 24.w..height = 24.w..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC) ),
              ),
              Container(
                margin:  EdgeInsets.symmetric(horizontal: 20.w,vertical: context.mediaQueryPadding.bottom + 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _button(icon: "videocall_ico_loudspeaker",on: false),
                    _button(icon: "videocall_ico_video",on: false),
                    _button(icon: "videocall_ico_mute",on: false),
                    _hungUpButton()
                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }


  Widget _button({required String icon,required bool on}){
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF.adapterDark(Styles.c_262626),
        border: Border.all(color: Styles.c_EDEDED.adapterDark(Styles.c_161616)),
        borderRadius: BorderRadius.circular(999)
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: on ? ("${icon}_act".svg.toSvg..width = 24.w..height = 24.w) : ("${icon}_nor".svg.toSvg..width = 24.w..height = 24.w..color = Styles.c_333333.adapterDark(Styles.c_999999)) ,
        ),
      ),
    );
  }

  Widget _hungUpButton(){
    return ClipOval(
      child: Container(
        width: 56.w,
        height: 56.w,
        color: Styles.c_DE473E,
        child: Center(
          child: "videocall_ico_end".svg.toSvg..width = 24.w..height = 24.w,
        ),
      ),
    );
  }
}
