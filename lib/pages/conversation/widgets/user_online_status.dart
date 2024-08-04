import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/im_callback.dart';
import 'package:owlpro_app/pages/conversation/conversation_logic.dart';

class UserOnlineStatus extends StatelessWidget {
   UserOnlineStatus({super.key});

  final logic = Get.find<ConversationLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4).w,
      decoration: BoxDecoration(
          color: logic.imStatus.value == IMSdkStatus.connectionFailed
              ? Styles.c_DE473E.withOpacity(0.05)
              : Styles.c_0C8CE9.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.r)),
      child: Center(
        child: logic.imStatus.value.name.tr.toText
          ..style = logic.imStatus.value == IMSdkStatus.connectionFailed
              ? Styles.ts_DE473E_10
              : Styles.ts_0C8CE9_10,
      ),
    );
  }
}
