import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:owlpro_app/pages/account/account_binding.dart';
import 'package:owlpro_app/pages/account/account_page.dart';
import 'package:owlpro_app/pages/account/edit/account_edit_binding.dart';
import 'package:owlpro_app/pages/account/edit/account_edit_page.dart';
import 'package:owlpro_app/pages/chat/chat_binding.dart';
import 'package:owlpro_app/pages/chat/chat_page.dart';
import 'package:owlpro_app/pages/chat/chat_setup/chat_setup_binding.dart';
import 'package:owlpro_app/pages/chat/chat_setup/chat_setup_view.dart';
import 'package:owlpro_app/pages/chat/group_chat_setup/group_chat_setup_binding.dart';
import 'package:owlpro_app/pages/chat/group_chat_setup/group_chat_setup_page.dart';
import 'package:owlpro_app/pages/contacts/add_by_search/add_by_search_binding.dart';
import 'package:owlpro_app/pages/contacts/add_by_search/add_by_search_page.dart';
import 'package:owlpro_app/pages/contacts/add_group/add_group_binding.dart';
import 'package:owlpro_app/pages/contacts/add_group/add_group_page.dart';
import 'package:owlpro_app/pages/contacts/black_list/black_list_binding.dart';
import 'package:owlpro_app/pages/contacts/black_list/black_list_page.dart';
import 'package:owlpro_app/pages/contacts/group_list/group_list_binding.dart';
import 'package:owlpro_app/pages/contacts/group_list/group_list_page.dart';
import 'package:owlpro_app/pages/contacts/new_friend/new_friend_binding.dart';
import 'package:owlpro_app/pages/contacts/new_friend/new_friend_page.dart';
import 'package:owlpro_app/pages/contacts/select_contacts/friend_list/friend_list_binding.dart';
import 'package:owlpro_app/pages/contacts/select_contacts/friend_list/friend_list_view.dart';
import 'package:owlpro_app/pages/contacts/select_contacts/select_contacts_binding.dart';
import 'package:owlpro_app/pages/contacts/select_contacts/select_contacts_view.dart';
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
import 'package:owlpro_app/pages/transfer/asset_token/asset_token_binding.dart';
import 'package:owlpro_app/pages/transfer/asset_token/asset_token_page.dart';
import 'package:owlpro_app/pages/transfer/trade_detail/trade_detail_binding.dart';
import 'package:owlpro_app/pages/transfer/trade_detail/trade_detail_page.dart';
import 'package:owlpro_app/pages/transfer/trade_list/trade_list_binding.dart';
import 'package:owlpro_app/pages/transfer/transfer_binding.dart';
import 'package:owlpro_app/pages/transfer/transfer_page.dart';
import 'package:owlpro_app/pages/user_profile/qrcode/user_qrcode_binding.dart';
import 'package:owlpro_app/pages/user_profile/qrcode/user_qrcode_page.dart';
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
import 'package:owlpro_app/pages/user_profile/user_profile_binding.dart';
import 'package:owlpro_app/pages/user_profile/user_profile_page.dart';
import 'package:owlpro_app/routes/app_routes.dart';

import '../pages/chat/group_chat_setup/group_member_list/group_member_list_binding.dart';
import '../pages/chat/group_chat_setup/group_member_list/group_member_list_view.dart';
import '../pages/transfer/trade_list/trade_list_page.dart';

class AppPages {
  static _pageBuilder({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    Transition? transition,
    bool preventDuplicates = true,
  }) =>
      GetPage(
        name: name,
        page: page,
        binding: binding,
        preventDuplicates: preventDuplicates,
        transition: transition ?? Transition.cupertino,
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
        name: AppRoutes.accountInfo,
        page: () => AccountPage(),
        binding: AccountBinding(),
        preventDuplicates: false),
    _pageBuilder(
        name: AppRoutes.accountInfoEdit,
        page: () => AccountEditPage(),
        binding: AccountEditBinding()),
    _pageBuilder(
        name: AppRoutes.userProfile,
        page: () => UserProfilePage(),
        binding: UserProfileBinding(),
        preventDuplicates: false),
    _pageBuilder(
        name: AppRoutes.userQRcode,
        page: () => UserQrcodePage(),
        binding: UserQrcodeBinding(),
        preventDuplicates: false),
    _pageBuilder(
      name: AppRoutes.assetToken,
      page: () => AssetTokenPage(),
      binding: AssetTokenBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.transfer,
      page: () => TransferPage(),
      binding: TransferBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.tradeDetail,
      preventDuplicates: false,
      page: () => TradeDetailPage(),
      binding: TradeDetailBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.tradeList,
      preventDuplicates: false,
      page: () => TradeListPage(),
      binding: TradeListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.receipt,
      page: () => ReceiptPage(),
      binding: ReceiptBinding(),
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
    _pageBuilder(
        name: AppRoutes.contactAddBySearch,
        page: () => AddBySearchPage(),
        binding: AddBySearchBinding()),
    _pageBuilder(
        name: AppRoutes.startAddGroup,
        page: () => AddGroupPage(),
        binding: AddGroupBinding()),
    _pageBuilder(
        name: AppRoutes.startFriendRequests,
        page: () => NewFriendPage(),
        binding: NewFriendBinding()),
    _pageBuilder(
        name: AppRoutes.startBlackList,
        page: () => BlackListPage(),
        binding: BlackListBinding()),
    _pageBuilder(
        name: AppRoutes.startGroupList,
        page: () => GroupListPage(),
        binding: GroupListBinding()),
    _pageBuilder(
      name: AppRoutes.groupMemberList,
      page: () => GroupMemberListPage(),
      binding: GroupMemberListBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chat,
      page: () => ChatPage(),
      binding: ChatBinding(),
      preventDuplicates: false,
    ),
    _pageBuilder(
      name: AppRoutes.groupChatSetup,
      page: () => GroupChatSetupPage(),
      binding: GroupChatSetupBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContacts,
      page: () => SelectContactsPage(),
      binding: SelectContactsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.selectContactsFromFriends,
      page: () => SelectContactsFromFriendsPage(),
      binding: SelectContactsFromFriendsBinding(),
    ),
    _pageBuilder(
      name: AppRoutes.chatSetup,
      page: () => ChatSetupPage(),
      binding: ChatSetupBinding(),
    ),
  ];
}
