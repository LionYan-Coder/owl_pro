import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:owlpro_app/pages/chat/widgets/user_online_status.dart';

class ChatLogic extends GetxController {
  final userStatus = UserStatus.offline.obs;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _updateConnectionStatus(result);
    });
  }

  void _checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      userStatus.value = UserStatus.offline;
    } else {
      userStatus.value = UserStatus.online;
    }
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }
}
