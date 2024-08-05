import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class LiveRoomPage extends StatelessWidget {
  const LiveRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
