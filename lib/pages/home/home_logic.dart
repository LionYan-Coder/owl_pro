import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owlpro_app/core/controller/app_controller.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/core/controller/push_controller.dart';
import 'package:rxdart/rxdart.dart';

class HomeLogic extends GetxController {
  final pushLogic = Get.find<PushController>();
  final imLogic = Get.find<IMController>();
  final initLogic = Get.find<AppController>();
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final unhandledFriendApplicationCount = 0.obs;
  final unhandledGroupApplicationCount = 0.obs;
  final unhandledCount = 0.obs;
  final _errorController = PublishSubject<String>();
  RxInt currentPage = 0.obs;

  Function()? onScrollToUnreadMessage;

  List<String> tabs = [
    "tab_ico_chat",
    "tab_ico_intimate",
    "tab_ico_discover",
    "tab_ico_me"
  ];

  onChangePage(int index) {
    currentPage.value = index;
  }

  scrollToUnreadMessage(index) {
    onScrollToUnreadMessage?.call();
  }

  _getUnreadMsgCount() {
    OwlIM.iMManager.conversationManager.getTotalUnreadMsgCount().then((count) {
      unreadMsgCount.value = int.tryParse(count) ?? 0;
      initLogic.showBadge(unreadMsgCount.value);
    });
  }

  void getUnhandledFriendApplicationCount() async {
    var i = 0;
    var list = await OwlIM.iMManager.friendshipManager
        .getFriendApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleFriendApplication();
    haveReadList ??= <String>[];
    for (var info in list) {
      var id = IMUtils.buildFriendApplicationID(info);
      if (!haveReadList.contains(id)) {
        if (info.handleResult == 0) i++;
      }
    }
    unhandledFriendApplicationCount.value = i;
    unhandledCount.value = unhandledGroupApplicationCount.value + i;
  }

  void getUnhandledGroupApplicationCount() async {
    var i = 0;
    var list =
        await OwlIM.iMManager.groupManager.getGroupApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleGroupApplication();
    haveReadList ??= <String>[];
    for (var info in list) {
      var id = IMUtils.buildGroupApplicationID(info);
      if (!haveReadList.contains(id)) {
        if (info.handleResult == 0) i++;
      }
    }
    unhandledGroupApplicationCount.value = i;
    unhandledCount.value = unhandledFriendApplicationCount.value + i;
  }

  @override
  void onInit() {
    imLogic.unreadMsgCountEventSubject.listen((value) {
      unreadMsgCount.value = value;
    });
    imLogic.friendApplicationChangedSubject.listen((value) {
      getUnhandledFriendApplicationCount();
    });
    imLogic.groupApplicationChangedSubject.listen((value) {
      getUnhandledGroupApplicationCount();
    });
    super.onInit();
  }

  @override
  void onReady() {
    _getUnreadMsgCount();
    getUnhandledFriendApplicationCount();
    getUnhandledGroupApplicationCount();
    super.onReady();
  }

  @override
  void onClose() {
    _errorController.close();
    super.onClose();
  }
}
