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
import 'package:owlpro_app/pages/account/list/account_list_binding.dart';
import 'package:owlpro_app/pages/account/list/account_list_page.dart';
import 'package:owlpro_app/pages/mine/qrcode/mine_qrcode_binding.dart';
import 'package:owlpro_app/pages/mine/qrcode/mine_qrcode_page.dart';
import 'package:owlpro_app/pages/receipt/receipt_binding.dart';
import 'package:owlpro_app/pages/receipt/receipt_page.dart';
import 'package:owlpro_app/pages/setting/language/setting_language_binding.dart';
import 'package:owlpro_app/pages/setting/language/setting_language_page.dart';
import 'package:owlpro_app/pages/setting/password/setting_password_binding.dart';
import 'package:owlpro_app/pages/setting/password/setting_password_page.dart';
import 'package:owlpro_app/pages/setting/setting_binding.dart';
import 'package:owlpro_app/pages/setting/setting_page.dart';
import 'package:owlpro_app/pages/setting/theme/setting_theme_binding.dart';
import 'package:owlpro_app/pages/setting/theme/setting_theme_page.dart';
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
      page: () => const LoginReadyPage(),
    ),
    _pageBuilder(
      name: AppRoutes.loginCreate,
      page: () => LoginCreatePage(),
      binding: LoginBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.loginRestore,
      page: () => LoginRestorePage(),
      binding: LoginBinding(),
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
    _pageBuilder(
      name: AppRoutes.receipt,
      page: () => ReceiptPage(),
      binding: ReceiptBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.mineQRcode,
      page: () => MineQrcodePage(),
      binding: MineQrcodeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.setting,
      page: () => SettingPage(),
      binding: SettingBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.settingPassword,
      page: () => SettingPasswordPage(),
      binding: SettingPasswordBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.settingTheme,
      page: () => SettingThemePage(),
      binding: SettingThemeBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.settingLanguage,
      page: () => const SettingLanguagePage(),
      binding: SettingLanguageBinding(),
    ),
  ];
}
