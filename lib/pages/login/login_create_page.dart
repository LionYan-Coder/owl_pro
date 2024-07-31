import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/login/login_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class LoginCreatePage extends StatelessWidget {
  LoginCreatePage({super.key});

  final logic = Get.find<LoginLogic>();

  Widget success() {
    return "sign_create_success_title".tr.toText
      ..style = Styles.ts_333333_20_bold.adapterDark(Styles.ts_FFFFFF_20_bold);
  }

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
                  logic.loading.value
                      ? const CircularProgressIndicator.adaptive()
                      : success()
                ],
              )),
              Stack(
                children: [
                  "sign_create_button".tr.toButton
                    ..loading = logic.loading.value
                    ..onPressed = () async {
                      await logic.createWallet();
                      AppNavigator.startLogin();
                    }
                    ..margin = EdgeInsets.symmetric(
                        horizontal: 64.w,
                        vertical: 24.w + context.mediaQueryPadding.bottom),
                ],
              )
            ],
          ),
        ));
  }
}
