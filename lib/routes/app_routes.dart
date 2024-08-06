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

  static const transfer = '/transfer';
  static const tradeDetail = '/trade/detail';
  static const tradeList = '/trade/list';
  static const assetToken = '/asset/token';
  static const receipt = '/receipt';

  static const contactAddBySearch = "/contact/add_by_search";
  static const startFriendRequests = '/contact/new_friend';
  static const startGroupList = '/contact/group_list';
  static const startBlackList = '/contact/black_list';
  static const startAddGroup = '/contact/addGroup';
  static const groupMemberList = '/group_member_list';
  static const selectContactsFromFriends = '/select_contacts_from_friends';
    static const selectContacts = '/select_contacts';

  static const chat = '/chat';
  static const chatSetup = '/chat_setup';
  static const liveRoom = '/live_room';

  static const groupChatSetup = '/group_chat_setup';
}
