import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:sprintf/sprintf.dart';

import 'group_list_logic.dart';

class GroupListPage extends StatelessWidget {
  final logic = Get.find<GroupListLogic>();

  GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: "group_list_title".tr),
      body: Column(
        children: [
       Padding(
         padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 24.w),
         child: Input(
               controller: logic.searchCtrl,
          name: "search",
          hintText: "search".tr,
          prefixIcon: Icon(
            Icons.search,
            color: Styles.c_999999.adapterDark(Styles.c_666666),
          ),
         ),
       ),
          Expanded(
            child: Obx(
              () {
                final key = logic.searchKey;
                final filterList = logic.allList.where((e) => e.groupName!.contains(key)).toList();
                return ListView.builder(
                    itemCount: filterList.length,
                    itemBuilder: (_, index) => _buildItemView(filterList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemView(GroupInfo info) => Ink(
        height: 64.h,
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: () => logic.toGroupChat(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                AvatarView(
                  url: info.faceURL,
                  text: info.groupName,
                  isGroup: true,
                ),
                12.gaph,
            (info.groupName ?? '').toText
              ..style =
              Styles.ts_333333_16_medium.adapterDark(Styles.ts_CCCCCC_16_medium),

              ],
            ),
          ),
        ),
      );
}
