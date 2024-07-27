import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class GuideLogic extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  Timer? _timer;

  void startLogin() async {
    await DataSp.putIsInit();
    AppNavigator.startLoginReady();
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dx < -15) {
      if (animationController.value == 0) {
        animationController.animateTo(0.2);
      } else if (animationController.value >= 0.2 &&
          animationController.value <= 0.4) {
        animationController.animateTo(0.4);
      }
    } else if (details.delta.dx > 15) {
      if (animationController.value >= 0 && animationController.value <= 0.2) {
        animationController.animateTo(0.0);
      } else if (animationController.value > 0.2 &&
          animationController.value <= 0.4) {
        animationController.animateTo(0.2);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (animationController.value >= 0.4) {
        _timer?.cancel();
      } else {
        animationController.animateTo(animationController.value + 0.2);
      }
    });
  }

  @override
  void onInit() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6));
    animationController.animateTo(0.0);
    _startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    animationController.dispose();
    super.onClose();
  }
}
