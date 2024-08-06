import 'dart:async';

import 'package:dart_date/dart_date.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';

enum RequestNewFriendStatus { pending, accepted, rejected, expired }

class NewFriendLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final homeLogic = Get.find<HomeLogic>();
  final applicationList = <FriendApplicationInfo>[].obs;
  late StreamSubscription faSub;

  @override
  void onInit() {
    faSub = imLogic.friendApplicationChangedSubject.listen((value) {
      _getFriendRequestsList();
    });
    super.onInit();
  }

  @override
  void onReady() {
    _getFriendRequestsList();
    super.onReady();
  }

  @override
  void onClose() {
    faSub.cancel();
    homeLogic.getUnhandledFriendApplicationCount();
    super.onClose();
  }

  void _getFriendRequestsList() async {
    final list = await Future.wait([
      OpenIM.iMManager.friendshipManager.getFriendApplicationListAsRecipient(),
      OpenIM.iMManager.friendshipManager.getFriendApplicationListAsApplicant(),
    ]);

    final allList = <FriendApplicationInfo>[];
    allList
      ..addAll(list[0])
      ..addAll(list[1]);

    allList.sort((a, b) {
      if (a.createTime! > b.createTime!) {
        return -1;
      } else if (a.createTime! < b.createTime!) {
        return 1;
      }
      return 0;
    });

    var haveReadList = DataSp.getHaveReadUnHandleFriendApplication();
    haveReadList ??= <String>[];
    for (var e in list[0]) {
      var id = IMUtils.buildFriendApplicationID(e);
      if (!haveReadList.contains(id)) {
        haveReadList.add(id);
      }
    }
    DataSp.putHaveReadUnHandleFriendApplication(haveReadList);
    applicationList.assignAll(allList);
  }

  bool isISendRequest(FriendApplicationInfo info) =>
      info.fromUserID == OpenIM.iMManager.userID;

  String status(FriendApplicationInfo info) {
    final prefix = isISendRequest(info) ? 'request' : 'receive';
    String text = '';
    // 如果创建时间大于14天就过期
    if (DateTime.fromMillisecondsSinceEpoch(info.createTime ?? 0)
            .compareTo(DateTime.now().subDays(14)) <=
        0) {
      text = RequestNewFriendStatus.expired.name;
    } else if (info.handleResult == 0) {
      text = RequestNewFriendStatus.pending.name;
    } else if (info.handleResult == 1) {
      text = "${prefix}_${RequestNewFriendStatus.accepted.name}";
    } else if (info.handleResult == -1) {
      text = "${prefix}_${RequestNewFriendStatus.rejected.name}";
    }

    return text;
  }

  void acceptFriendApplication(FriendApplicationInfo info) async {
    LoadingView.singleton
        .wrap(
            asyncFunction: () => OpenIM.iMManager.friendshipManager
                .acceptFriendApplication(userID: info.fromUserID!))
        .then(_addSuccessfully)
        .catchError((_) => IMViews.showToast(StrRes.addFailed));
  }

  void refuseFriendApplication(FriendApplicationInfo info) async {
    LoadingView.singleton
        .wrap(
            asyncFunction: () => OpenIM.iMManager.friendshipManager
                .refuseFriendApplication(userID: info.fromUserID!))
        .then(_rejectSuccessfully)
        .catchError((_) => IMViews.showToast(StrRes.rejectFailed));
  }

  _addSuccessfully(_) {
    IMViews.showToast(StrRes.addSuccessfully);
  }

  _rejectSuccessfully(_) {
    IMViews.showToast(StrRes.rejectSuccessfully);
  }
}
