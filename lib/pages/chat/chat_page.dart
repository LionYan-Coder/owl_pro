import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/chat/widgets/dropdown_add.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4).w,
                      decoration: BoxDecoration(
                          color: Styles.c_0C8CE9.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(4.r)),
                      child: Center(
                        child: "device_online".tr.toText
                          ..style = Styles.ts_0C8CE9_10,
                      ),
                    )
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
