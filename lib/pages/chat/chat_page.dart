import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/chat/chat_logic.dart';
import 'package:owlpro_app/pages/chat/widgets/dropdown_add.dart';
import 'package:owlpro_app/pages/chat/widgets/user_online_status.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final imLogic = Get.find<IMController>();
  final logic = Get.find<ChatLogic>();

  @override
  Widget build(BuildContext context) {
    final status = imLogic.userInfo.value.status;
    Logger.print("status: $status");
    return SafeArea(
      child: Column(
        children: [chatNavbar()],
      ),
    );
  }

  Widget chatNavbar() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 6).w,
                child: Row(
                  children: [
                    "chat_list_title".tr.toText
                      ..style = Styles.ts_333333_18_bold
                          .adapterDark(Styles.ts_CCCCCC_18_bold),
                    6.gaph,
                    Obx(() => UserOnlineStatus(status: logic.userStatus.value))
                  ],
                ),
              ),
              Row(
                children: [
                  "${"chat_list_online_count".tr}1256".toText
                    ..style = Styles.ts_0C8CE9_14,
                  8.gaph,
                  "${"chat_list_online_user_count".tr}15632".toText
                    ..style = Styles.ts_0C8CE9_14,
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: 2.w,
          right: 48.w,
          child: IconButton(
              onPressed: () {
                //TODO 搜索功能
              },
              icon: "nvbar_ico_search".svg.toSvg
                ..width = 24.w
                ..height = 24.w
                ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
        ),
        DropdownAdd()
      ],
    );
  }
}
