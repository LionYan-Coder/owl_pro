import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import 'im_controller.dart';

class UserStatusController extends GetxController{
  final imLogic = Get.find<IMController>();
  final userStatusList = <UserStatusInfo>[].obs;

  late StreamSubscription userStatusSub;


  @override
  void onInit() {
    _getSubUserStatus();
    userStatusSub = imLogic.userStatusSubject.listen(_onChangeUserStatus);
    super.onInit();
  }


  bool getOnline(String userID){
    final index =  userStatusList.indexWhere((e) => e.userID == userID);
    if (index >= 0) {
      if (userStatusList[index].status == 1){
        return true;
      }
    }

    return false;
  }

  _onChangeUserStatus(UserStatusInfo info) async {
    final index = userStatusList.indexWhere((e) => e.userID == info.userID);
    if (index >= 0){
      userStatusList[index].status = info.status;
    }
  }

  _getSubUserStatus() async {
    final list = await OpenIM.iMManager.userManager.getSubscribeUsersStatus();
    userStatusList.assignAll(list);
  }

  subUserStatus(List<String> userIds) async {
    final list = await OpenIM.iMManager.userManager.subscribeUsersStatus(userIds);
    userStatusList.assignAll(list);
  }

  unSubUserStatus(List<String> userIds) async {
    await OpenIM.iMManager.userManager.unsubscribeUsersStatus(userIds);
    userStatusList.removeWhere((e) => userIds.contains(e.userID));
  }

  Future<List<UserStatusInfo>> getUsersStatus(List<String> userIDs) async{
    return await OpenIM.iMManager.userManager.getUserStatus(userIDs);
  }
}