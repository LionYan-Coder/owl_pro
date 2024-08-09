import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class ContactLogic extends GetxController implements ViewUserProfileBridge {
  final imLogic = Get.find<IMController>();
  final homeLogic = Get.find<HomeLogic>();
  final friendApplicationList = <UserInfo>[];
  int get friendApplicationCount =>
      homeLogic.unhandledFriendApplicationCount.value;
  int get groupApplicationCount =>
      homeLogic.unhandledGroupApplicationCount.value;

  final userIDList = <String>[];

  @override
  void onInit() {
    // PackageBridge.selectContactsBridge = this;
    PackageBridge.viewUserProfileBridge = this;
    // PackageBridge.scanBridge = this;

    super.onInit();
  }


  @override
  void onClose() {
    // PackageBridge.selectContactsBridge = null;
    PackageBridge.viewUserProfileBridge = null;
    // PackageBridge.scanBridge = null;
    super.onClose();
  }

  void newFriend() => AppNavigator.startFriendRequests();

  void myGroup() => AppNavigator.startGroupList();

  void myBlack() => AppNavigator.startBlackList();

  // @override
  // Future<T?>? selectContacts<T>(
  //   int type, {
  //   List<String>? defaultCheckedIDList,
  //   List? checkedList,
  //   List<String>? excludeIDList,
  //   bool openSelectedSheet = false,
  //   String? groupID,
  //   String? ex,
  // }) =>
  //     AppNavigator.startSelectContacts(
  //       action: type == 0
  //           ? SelAction.whoCanWatch
  //           : (type == 1 ? SelAction.remindWhoToWatch : SelAction.meeting),
  //       defaultCheckedIDList: defaultCheckedIDList,
  //       checkedList: checkedList,
  //       excludeIDList: excludeIDList,
  //       openSelectedSheet: openSelectedSheet,
  //       groupID: groupID,
  //       ex: ex,
  //     );

  @override
  viewUserProfile(String userID, String? nickname, String? faceURL, [String? groupID]) => AppNavigator.startUserProfile(
    userID: userID,
    nickname: nickname,
    faceURL: faceURL,
    groupID: groupID,
  );

  // @override
  // scanOutGroupID(String groupID) => AppNavigator.startGroupProfilePanel(
  //       groupID: groupID,
  //       joinGroupMethod: JoinGroupMethod.qrcode,
  //       offAndToNamed: true,
  //     );

  // @override
  // scanOutUserID(String userID) =>
  //     AppNavigator.startUserProfilePane(userID: userID, offAndToNamed: true);
}
