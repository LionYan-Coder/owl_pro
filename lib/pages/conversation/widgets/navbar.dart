import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/im_callback.dart';

import 'dropdown_add.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final IMSdkStatus status;
  const Navbar({super.key,required this.status});

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding:  EdgeInsets.only(left: 24.w, right: 24.w,top: context.mediaQueryPadding.top),
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
                          color: status == IMSdkStatus.connectionFailed
                              ? Styles.c_DE473E.withOpacity(0.05)
                              : Styles.c_0C8CE9.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(4.r)),
                      child: Center(
                        child: status.name.tr.toText
                          ..style = status == IMSdkStatus.connectionFailed
                              ? Styles.ts_DE473E_10
                              : Styles.ts_0C8CE9_10,
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
          top: 2.w + context.mediaQueryPadding.top,
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
        const DropdownAdd()
      ],
    );
  }
}
