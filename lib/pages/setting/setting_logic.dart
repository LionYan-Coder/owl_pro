import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:path_provider/path_provider.dart';

class SettingLogic extends GetxController {
  final mineLogic = Get.find<MineLogic>();

  final selectedLockTime = 0.obs;
  List<int> appLockTimeList = [
    const Duration(microseconds: 0).inMilliseconds,
    const Duration(minutes: 30).inMilliseconds,
    const Duration(hours: 1).inMilliseconds,
    const Duration(hours: 3).inMilliseconds,
    const Duration(hours: 12).inMilliseconds,
    const Duration(days: 1).inMilliseconds,
    const Duration(days: 3).inMilliseconds,
    const Duration(days: 7).inMilliseconds,
  ];

  Future<void> clearCache() async {
    await LoadingView.singleton
        .wrap(asyncFunction: () => DefaultCacheManager().emptyCache())
        .then((_) {
      ToastHelper.showToast(Get.context!, "clear_cache_success".tr);
    });
  }

  Future<String> getCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    int totalSize = await _getDirectorySize(tempDir);
    return _formatSize(totalSize);
  }

  Future<int> _getDirectorySize(Directory directory) async {
    int totalSize = 0;
    if (directory.existsSync()) {
      try {
        await for (var file in directory.list(recursive: true)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      } catch (e) {
        print('Failed to get directory size: $e');
      }
    }
    return totalSize;
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      // 转换为 MB
      double mb = bytes / (1024 * 1024);
      return "${mb.toStringAsFixed(2)} MB";
    } else {
      // 转换为 KB
      double kb = bytes / 1024;
      return "${kb.toStringAsFixed(2)} KB";
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
                    if (appLockTimeList[index]
                            .dateTime
                            .millisecondsSinceEpoch ==
                        0) {
                      return Center(
                        child: Text("never_verify".tr),
                      );
                    }
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
