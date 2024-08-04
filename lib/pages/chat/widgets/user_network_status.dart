import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/im_callback.dart';
import 'package:owlpro_app/pages/chat/chat_logic.dart';

class UserOnlineStatus extends StatelessWidget {
  UserOnlineStatus({super.key});

  final logic = Get.find<ChatLogic>(tag: GetTags.chat);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.h,
      padding: const EdgeInsets.symmetric(horizontal: 4).w,
      decoration: BoxDecoration(
          color: logic.syncStatus.value == IMSdkStatus.connectionFailed
              ? Styles.c_DE473E.withOpacity(0.05)
              : Styles.c_0C8CE9.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.r)),
      child: Center(
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 6.w,
                height: 6.w,
                color: logic.syncStatus.value == IMSdkStatus.connectionFailed ? Styles.c_DE473E
                    : Styles.c_1ED386,
              ),
            ),
            2.gaph,
            logic.syncStatus.value.name.tr.toText
              ..style = logic.syncStatus.value  == IMSdkStatus.connectionFailed
                  ? Styles.ts_DE473E_10
                  : Styles.ts_0C8CE9_10
          ],
        ),
      ),
    );
  }
}
