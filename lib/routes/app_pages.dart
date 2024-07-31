import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:owlpro_app/pages/guide/guide_binding.dart';
import 'package:owlpro_app/pages/guide/guide_page.dart';
import 'package:owlpro_app/pages/home/home_binding.dart';
import 'package:owlpro_app/pages/home/home_page.dart';
import 'package:owlpro_app/pages/login/login_binding.dart';
import 'package:owlpro_app/pages/login/login_create_page.dart';
import 'package:owlpro_app/pages/login/login_ready_page.dart';
import 'package:owlpro_app/pages/login/login_restore_page.dart';
import 'package:owlpro_app/pages/login/loign_page.dart';
import 'package:owlpro_app/pages/mine/account_list/account_list_binding.dart';
import 'package:owlpro_app/pages/mine/account_list/account_list_page.dart';
import 'package:owlpro_app/pages/splash/splash_binding.dart';
import 'package:owlpro_app/pages/splash/splash_page.dart';
import 'package:owlpro_app/routes/app_routes.dart';

class AppPages {
  static _pageBuilder({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    bool preventDuplicates = true,
  }) =>
      GetPage(
        name: name,
        page: page,
        binding: binding,
        preventDuplicates: preventDuplicates,
        transition: Transition.cupertino,
        popGesture: true,
      );

  static final routes = <GetPage>[
    _pageBuilder(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.guide,
      page: () => GuidePage(),
      binding: GuideBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.loginReady,
      page: () => LoginReadyPage(),
      binding: LoginBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.loginCreate,
      page: () => LoginCreatePage(),
    ),
    _pageBuilder(
      name: AppRoutes.login,
      page: () => LoginPage(),
    ),
    _pageBuilder(
      name: AppRoutes.loginRestore,
      page: () => LoginRestorePage(),
    ),
    _pageBuilder(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.accountList,
      page: () => AccountListPage(),
      binding: AccountListBinding(),
    ),
  ];
}
