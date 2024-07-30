import 'dart:async';

import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class SplashLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  String? get userID => DataSp.userID;

  String? get token => DataSp.imToken;

  bool? get isInit => DataSp.isInit;

  late StreamSubscription? initializedSub;

  @override
  void onInit() {
    initializedSub = imLogic.initializedSubject.listen((value) {
      Logger.print('---------------------initialized---------------------');
      if (null != userID && null != token) {
        _login();
      } else {
        if (isInit == false) {
          AppNavigator.startGuide();
        } else {
          AppNavigator.startLoginReady();
        }
        // AppNavigator.startLogin();
      }
    });
    super.onInit();
  }

  _login() async {
    try {
      Logger.print('---------login---------- userID: $userID, token: $token');
      await imLogic.login(userID!, token!);
      Logger.print('---------im login success-------');
      // Logger.print('---------push login success----');
      AppNavigator.startSplashToMain(isAutoLogin: true);
    } catch (e, s) {
      IMViews.showToast('$e $s');
      await DataSp.removeLoginCertificate();
      AppNavigator.startLoginReady();
    }
  }

  @override
  void onClose() {
    initializedSub?.cancel();
    super.onClose();
  }
}
