import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import 'im_controller.dart';

class UserStatusController extends GetxController{
  final imLogic = Get.find<IMController>();
  final subUserStatusList = <UserStatusInfo>[].obs;

  late StreamSubscription userStatusSub;


  @override
  void onInit() {
    userStatusSub = imLogic.userStatusSubject.listen(_onChangeUserStatus);
    super.onInit();
  }

  @override
  void onReady() {
    _getSubUserStatus();
    super.onReady();
  }


  _onChangeUserStatus(UserStatusInfo info) async {
    final index = subUserStatusList.indexWhere((e) => e.userID == info.userID);
    if (index >= 0){
      subUserStatusList[index].status = info.status;
    }
  }

  _getSubUserStatus() async {
    final list = await OpenIM.iMManager.userManager.getSubscribeUsersStatus();
    subUserStatusList.assignAll(list);
  }

  subUserStatus(List<String> userIds) async {
    final list = await OpenIM.iMManager.userManager.subscribeUsersStatus(userIds);
    subUserStatusList.assignAll(list);
  }

  unSubUserStatus(List<String> userIds) async {
    await OpenIM.iMManager.userManager.unsubscribeUsersStatus(userIds);
    subUserStatusList.removeWhere((e) => userIds.contains(e.userID));
  }
}