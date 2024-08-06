import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class BlackListLogic extends GetxController{
  final imLogic = Get.find<IMController>();
  final homeLogic = Get.find<HomeLogic>();
  final blackFriendList = <ISUserInfo>[].obs;



  @override
  void onReady() {
    _getFriendList();
    super.onReady();
  }


  _getFriendList() async {
    final list = await OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) => list.where(_filterBlacklist))
        .then((list) => list.map((e) {
      final fullUser = FullUserInfo.fromJson(e);
      final user = fullUser.friendInfo != null
          ? ISUserInfo.fromJson(fullUser.friendInfo!.toJson())
          : ISUserInfo.fromJson(fullUser.publicInfo!.toJson());
      return user;
    }).toList());

    blackFriendList.addAll(list.cast<ISUserInfo>());
  }

  bool _filterBlacklist(e) {
    final user = FullUserInfo.fromJson(e);
    final isBlack = user.blackInfo != null;

    if (isBlack) {
      return true;
    } else {
      return false;
    }
  }



  void removeBlacklist(ISUserInfo userInfo) async {
    await OpenIM.iMManager.friendshipManager.removeBlacklist(
      userID: userInfo.userID!,
    );
    _getFriendList();
  }
}