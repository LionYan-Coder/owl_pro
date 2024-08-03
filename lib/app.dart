import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/core/controller/permission_controller.dart';
import 'package:owlpro_app/core/controller/push_controller.dart';
import 'package:owlpro_app/core/controller/theme_controller.dart';
import 'package:owlpro_app/routes/app_pages.dart';
import 'package:owlpro_app/routes/app_routes.dart';
import 'package:owlpro_app/widgets/app_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class OwlApp extends StatelessWidget {
  const OwlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ThemeController(),
        builder: (theme) {
          return AppView(
              builder: (locale, builder) => GetMaterialApp(
                    debugShowCheckedModeBanner: true,
                    // enableLog: true,
                    builder: builder,
                    // logWriterCallback: Logger.print,
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
                    theme: Styles.lightTheme,
                    darkTheme: Styles.darkTheme,
                    themeMode: theme.appTheme,
                    supportedLocales: const [
                      Locale('zh', 'CN'),
                      Locale('en', 'US')
                    ],
                    getPages: AppPages.routes,
                    initialBinding: InitBinding(),
                    initialRoute: AppRoutes.splash,
                  ));
        });
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionController>(PermissionController());
    Get.put<IMController>(IMController());
    Get.put<PushController>(PushController());
    Get.put<CacheController>(CacheController());
    Get.put<DownloadController>(DownloadController());
  }
}
