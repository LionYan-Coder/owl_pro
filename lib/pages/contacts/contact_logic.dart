import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
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

  final friendList = <ISUserInfo>[
    ISUserInfo.fromJson({"tagIndex": "↑"})
  ].obs;
  final userIDList = <String>[];

  @override
  void onInit() {
    // PackageBridge.selectContactsBridge = this;
    // PackageBridge.viewUserProfileBridge = this;
    // PackageBridge.scanBridge = this;

    super.onInit();
  }

  @override
  void onReady() {
    _getFriendList();
    super.onReady();
  }

  @override
  void onClose() {
    // PackageBridge.selectContactsBridge = null;
    // PackageBridge.viewUserProfileBridge = null;
    // PackageBridge.scanBridge = null;
    super.onClose();
  }

  _getFriendList() async {
    final list = await OwlIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) => list.where(_filterBlacklist))
        .then((list) => list.map((e) {
              final fullUser = FullUserInfo.fromJson(e);
              final user = fullUser.friendInfo != null
                  ? ISUserInfo.fromJson(fullUser.friendInfo!.toJson())
                  : ISUserInfo.fromJson(fullUser.publicInfo!.toJson());
              return user;
            }).toList())
        .then((list) => IMUtils.convertToAZList(list));

    onUserIDList(userIDList);

    friendList.insertAll(1, list.cast<ISUserInfo>());
  }

  bool _filterBlacklist(e) {
    final user = FullUserInfo.fromJson(e);
    final isBlack = user.blackInfo != null;

    if (isBlack) {
      return false;
    } else {
      userIDList.add(user.userID);
      return true;
    }
  }

  void onUserIDList(List<String> userIDList) {}

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
  viewUserProfile(UserFullInfo user) => AppNavigator.startUserProfile(user);

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
