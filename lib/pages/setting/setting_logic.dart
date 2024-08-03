import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';

class SettingLogic extends GetxController {
  final mineLogic = Get.find<MineLogic>();

  final selectedLockTime = 0.obs;
  List<int> appLockTimeList = [
    const Duration(minutes: 30).inMilliseconds,
    const Duration(hours: 1).inMilliseconds,
    const Duration(hours: 3).inMilliseconds,
    const Duration(hours: 12).inMilliseconds,
    const Duration(days: 1).inMilliseconds,
    const Duration(days: 3).inMilliseconds,
    const Duration(days: 7).inMilliseconds,
  ];

  void onClearCache() async {
    await SpUtil().clear();
    calculateSharedPreferencesSize();
  }

  Future<String> calculateSharedPreferencesSize() async {
    final keys = SpUtil().getKeys() ?? Set.from({});

    int totalSize = 0;

    for (var key in keys) {
      final value = SpUtil().getSp()?.get(key);
      final keySize = utf8.encode(key).length;
      int valueSize;

      if (value is String) {
        valueSize = utf8.encode(value).length;
      } else if (value is int) {
        valueSize = 8; // 64-bit integer
      } else if (value is double) {
        valueSize = 8; // 64-bit double
      } else if (value is bool) {
        valueSize = 1; // 1 byte for boolean
      } else if (value is List<String>) {
        valueSize = value.fold(
            0, (prev, element) => prev + utf8.encode(element).length);
      } else {
        valueSize = 0;
      }

      totalSize += keySize + valueSize;
    }

    double sizeInMB = totalSize / (1024 * 1024);
    if (sizeInMB >= 1) {
      return '${sizeInMB.toStringAsPrecision(2)}M';
    } else {
      double sizeInKB = totalSize / 1024;
      return '${sizeInKB.toStringAsFixed(2)}KB';
    }
  }

  void openAppLock() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          height: 216.w,
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: "cancel".tr.toText
                        ..style = Styles.ts_999999_14
                            .adapterDark(Styles.ts_555555_14)),
                  TextButton(
                      onPressed: () async {
                        await DataSp.putVerifyGapPwdTime(
                            selectedLockTime.value);
                        mineLogic.verifyPwdGapTime.value =
                            selectedLockTime.value;
                        Get.back();
                      },
                      child: "confirm".tr.toText..style = Styles.ts_0C8CE9_14)
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                      initialItem:
                          appLockTimeList.indexOf(selectedLockTime.value)),
                  onSelectedItemChanged: (int index) {
                    selectedLockTime.value = appLockTimeList[index];
                  },
                  children: List<Widget>.generate(appLockTimeList.length,
                      (int index) {
                    return Center(
                        child: Text(DateUtil2.formattedTimes(
                            appLockTimeList[index].dateTime)));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
    );
  }

  @override
  void onInit() {
    selectedLockTime.value = mineLogic.verifyPwdGapTime.value;

    super.onInit();
  }
}
