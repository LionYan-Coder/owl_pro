import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

import 'friend_list/friend_list_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar(
            left: "contact_title".tr.toText
              ..style = Styles.ts_333333_18_bold
                  .adapterDark(Styles.ts_CCCCCC_18_bold),
            right: Row(
              children: [
                IconButton(
                    onPressed: () {
                      //TODO 搜索页
                    },
                    icon: "nvbar_ico_search".svg.toSvg
                      ..width = 24.w
                      ..height = 24.w
                      ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
                16.gaph
              ],
            )),
        body: FriendListPage());
  }
}
