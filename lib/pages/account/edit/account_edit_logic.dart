import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';

class AccountEditLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  late Rx<String> userID;
  late Rx<UserFullInfo> userInfo;
  final formKey = GlobalKey<FormBuilderState>();
  final loading = false.obs;
  // final uploadAvatarProgress = 0.obs;
  // final uploadCoverProgress = 0.obs;

  final avatarUrl = "".obs;
  final coverUrl = "".obs;

  void _fetchUserInfo() async {
    try {
      loading.value = true;
      final data = await Apis.queryMyFullInfo();
      if (data is UserFullInfo) {
        avatarUrl.value = data.faceURL ?? '';
        coverUrl.value = data.coverURL ?? '';
        userInfo.update((val) {
          val?.nickname = data.nickname;
          val?.faceURL = data.faceURL;
          val?.about = data.about;
          val?.address = data.address;
          val?.coverURL = data.coverURL;
          val?.publicKey = data.publicKey;
          val?.account = data.account;
        });
      }
    } catch (e) {
      Logger.print("AccountEditLogic_fetchUserInfo error = ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  void openPhotoSheet(String type) {
    IMViews.openPhotoSheet(
        onData: (path, url) async {
          if (type == 'faceURL') {
            avatarUrl.value = url ?? '';
          } else {
            coverUrl.value = url ?? '';
          }
        },
        quality: 15);
  }

  void submit() async {
    try {
      var state = formKey.currentState;
      if (jsonEncode(state?.initialValue) != jsonEncode(state?.instantValue) ||
          avatarUrl.value != userInfo.value.faceURL ||
          coverUrl.value != userInfo.value.coverURL) {
        final valid = state?.saveAndValidate(focusOnInvalid: false);
        if (valid == true) {
          loading.value = true;

          final nickname = state?.getRawValue("nickname");
          final account = state?.getRawValue("account");
          final about = state?.getRawValue("about");
          var faceURL = avatarUrl.value.isNotEmpty
              ? avatarUrl.value
              : userInfo.value.faceURL;
          await Apis.updateUserInfo(
              userID: userInfo.value.userID ?? '',
              nickname: nickname,
              account: account,
              faceURL: faceURL,
              coverURL: coverUrl.value,
              about: about);

          IMViews.showToast("change_success".tr);

          imLogic.userInfo.update((val) {
            val?.account = account;
            val?.nickname = nickname;
            val?.about = about;
            val?.faceURL = faceURL;
            val?.coverURL = coverUrl.value ?? '';
          });

          Get.back();
        }
      } else {
        IMViews.showToast("nochange".tr);
      }
    } catch (e) {
      Logger.print("AccountEditLogic-submit error ${e.toString()}");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onReady() {
    _fetchUserInfo();
    super.onReady();
  }

  @override
  void onInit() {
    userInfo = imLogic.userInfo;
    userID = Rx(Get.parameters["userID"] as String);
    super.onInit();
  }
}
