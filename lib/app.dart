import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/core/controller/permission_controller.dart';
import 'package:owlpro_app/widgets/app_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class OwlApp extends StatelessWidget {
  const OwlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppView(
        builder: (locale, builder) => GetMaterialApp(
              debugShowCheckedModeBanner: true,
              enableLog: true,
              logWriterCallback: Logger.print,
              translations: TranslationService(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              fallbackLocale: TranslationService.fallbackLocale,
              localeResolutionCallback: (locale, list) {
                Get.locale ??= locale;
                return locale;
              },
              locale: locale,
              supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
              // getPages: AppPages.routes,
              initialBinding: InitBinding(),
            ));
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionController>(PermissionController());
    Get.put<IMController>(IMController());
    // Get.put<PushController>(PushController());
    Get.put<CacheController>(CacheController());
    Get.put<DownloadController>(DownloadController());
  }
}
