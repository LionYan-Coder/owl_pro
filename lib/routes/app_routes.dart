abstract class AppRoutes {
  static const splash = '/splash';
  static const guide = '/guide';
  static const login = '/login';
  static const loginCreate = '/login_create';
  static const loginReady = '/login_ready';
  static const loginRestore = '/login_restore';
  static const home = '/home';

  static const userProfile = '/user/profile';
  static const userQRcode = '/user/qrcode';

  static const accountInfo = '/account';
  static const accountList = '/account/list';
  static const accountInfoEdit = '/account/:userID';

  static const setting = '/setting';
  static const settingLanguage = '/setting/language';
  static const settingTheme = '/setting/theme';
  static const settingPassword = '/setting/password';

  static const notify = '/norify';

  static const asset = '/asset';
  static const transfer = '/transfer';
  static const receipt = '/receipt';

  static const contactAddBySearch = "/contact/add_by_search";
  static const startFriendRequests = '/contact/new_friend';
  static const startGroupList = '/contact/group_list';
  static const startBlackList = '/contact/black_list';
}
