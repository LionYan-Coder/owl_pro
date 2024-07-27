import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/login/login_logic.dart';

class LoginCreatePage extends StatelessWidget {
  LoginCreatePage({super.key});

  final logic = Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(),
          body: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  "logo".png.toImage
                    ..width = 96.w
                    ..height = 96.w,
                  30.gapv,
                  LoadingSwitcher(
                    loading: logic.loading,
                    child: "sign_create_success_title".tr.toText
                      ..style = Styles.ts_333333_20_bold
                      ..darkColor = Styles.c_FFFFFF,
                  )
                ],
              )),
              Stack(
                children: [
                  "sign_create_button".tr.toButton
                    ..margin =
                        const EdgeInsets.symmetric(horizontal: 64, vertical: 24)
                            .w,
                  Positioned(
                      child: LoadingSwitcher(
                    loading: logic.loading,
                  ))
                ],
              )
            ],
          ),
        ));
  }
}
