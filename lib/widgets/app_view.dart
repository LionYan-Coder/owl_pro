import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/app_controller.dart';

class AppView extends StatelessWidget {
  const AppView({super.key, required this.builder});
  final Widget Function(Locale? locale, TransitionBuilder builder) builder;

  static TransitionBuilder _builder() => EasyLoading.init(
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(Config.textScaleFactor),
            ),
            child: widget!,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
        builder: (ctrl) => FocusDetector(
            onForegroundGained: () => ctrl.runningBackground(false),
            onForegroundLost: () => ctrl.runningBackground(true),
            child: ScreenUtilInit(
              designSize: const Size(Config.uiW, Config.uiH),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, child) => builder(ctrl.getLocale(), _builder()),
            )));
  }
}
