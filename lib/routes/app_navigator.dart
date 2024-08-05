import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owlpro_app/routes/app_routes.dart';

class AppNavigator {
  AppNavigator._();

  static void startGuide() {
    Get.offAllNamed(AppRoutes.guide);
  }

  static void startLoginReady() {
    Get.offAllNamed(AppRoutes.loginReady);
  }

  static void startLoginCreate() {
    Get.toNamed(AppRoutes.loginCreate);
  }

  static void startRestoreCreate() {
    Get.toNamed(AppRoutes.loginRestore);
  }

  static void startLogin() {
    Get.toNamed(AppRoutes.login);
  }

  static void startMain({bool isAutoLogin = false}) {
    Get.offAllNamed(
      AppRoutes.home,
      arguments: {'isAutoLogin': isAutoLogin},
    );
  }

  static void startSplashToMain({bool isAutoLogin = false}) {
    Get.offAndToNamed(
      AppRoutes.home,
      arguments: {'isAutoLogin': isAutoLogin},
    );
  }

  static void startAccountList() => Get.toNamed(
        AppRoutes.accountList,
      );

  static void startAccountInfo() => Get.toNamed(
        AppRoutes.accountInfo,
      );

  static void startAccountInfoEdit() => Get.toNamed(
        AppRoutes.accountInfoEdit,
      );

  static Future<dynamic>? startUserQRCode(UserFullInfo user) {
    GetTags.createUserProfileQRTags();
    return Get.toNamed(AppRoutes.userQRcode, arguments: user);
  }

  static Future<dynamic>? startUserProfile(UserFullInfo user) {
    GetTags.createUserProfileTag();
    return Get.toNamed(AppRoutes.userProfile, arguments: user);
  }

  static startSetting() => Get.toNamed(
        AppRoutes.setting,
      );

  static void startSettingLanguage() => Get.toNamed(
        AppRoutes.settingLanguage,
      );

  static void startSettingTheme() => Get.toNamed(
        AppRoutes.settingTheme,
      );

  static void startSettingPassword() => Get.toNamed(
        AppRoutes.settingPassword,
      );

  static void startNotify() => Get.toNamed(
        AppRoutes.notify,
      );

  static void startAsset() => Get.toNamed(
        AppRoutes.assetToken,
      );

  static void startTransfer() => Get.toNamed(
        AppRoutes.transfer,
      );

  static void startTradeDetail(
          {required TokenType token, required String txHash}) =>
      Get.toNamed(
        AppRoutes.tradeDetail,
        arguments: {"txHash": txHash, "token": token.name},
      );

  static void startTradeList({required TokenType token}) => Get.toNamed(
        AppRoutes.tradeList,
        arguments: token,
      );

  static void startReceipt() => Get.toNamed(
        AppRoutes.receipt,
      );

  static void startAddBySearch() => Get.toNamed(
        AppRoutes.contactAddBySearch,
      );

  static void startFriendRequests() => Get.toNamed(
        AppRoutes.startFriendRequests,
      );
  static void startGroupList() => Get.toNamed(
        AppRoutes.startGroupList,
      );
  static void startBlackList() => Get.toNamed(
        AppRoutes.startBlackList,
      );


  static Future<T?>? startChat<T>({
    required ConversationInfo conversationInfo,
    bool offUntilHome = true,
    String? draftText,
    Message? searchMessage,
  }) async {
    GetTags.createChatTag();

    final arguments = {
      'draftText': draftText,
      'conversationInfo': conversationInfo,
      'searchMessage': searchMessage,
    };

    return offUntilHome
        ? Get.offNamedUntil(
      AppRoutes.chat,
          (route) => route.settings.name == AppRoutes.home,
      arguments: arguments,
    )
        : Get.toNamed(
      AppRoutes.chat,
      arguments: arguments,
      preventDuplicates: false,
    );
  }


  static startLiveRoom() {
    return Get.toNamed(AppRoutes.liveRoom);
  }

  static startChatSetup({
    required ConversationInfo conversationInfo,
  }) =>
      Get.toNamed(AppRoutes.chatSetup, arguments: {
        'conversationInfo': conversationInfo,
      });



  static startOANtfList({required ConversationInfo info}) {}
}
