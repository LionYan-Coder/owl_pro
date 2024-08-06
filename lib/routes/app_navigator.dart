import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owlpro_app/pages/chat/group_chat_setup/group_member_list/group_member_list_logic.dart';
import 'package:owlpro_app/pages/contacts/select_contacts/select_contacts_logic.dart';
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

  static void startAddGroup() => Get.toNamed(
        AppRoutes.startAddGroup,
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

  static Future<T?>? startGroupMemberList<T>({
    required GroupInfo groupInfo,
    GroupMemberOpType opType = GroupMemberOpType.view,
  }) =>
      Get.toNamed(AppRoutes.groupMemberList, arguments: {
        'groupInfo': groupInfo,
        'opType': opType,
      });

  static startSelectContacts({
    required SelAction action,
    List<String>? defaultCheckedIDList,
    List<dynamic>? checkedList,
    List<String>? excludeIDList,
    bool openSelectedSheet = false,
    String? groupID,
    String? ex,
  }) =>
      Get.toNamed(AppRoutes.selectContacts, arguments: {
        'action': action,
        'defaultCheckedIDList': defaultCheckedIDList,
        'checkedList': IMUtils.convertCheckedListToMap(checkedList),
        'excludeIDList': excludeIDList,
        'openSelectedSheet': openSelectedSheet,
        'groupID': groupID,
        'ex': ex,
      });

  static startSelectContactsFromFriends() =>
      Get.toNamed(AppRoutes.selectContactsFromFriends);

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

  static startGroupChatSetup({
    required ConversationInfo conversationInfo,
  }) =>
      Get.toNamed(AppRoutes.groupChatSetup, arguments: {
        'conversationInfo': conversationInfo,
      });

  static startOANtfList({required ConversationInfo info}) {}
}
