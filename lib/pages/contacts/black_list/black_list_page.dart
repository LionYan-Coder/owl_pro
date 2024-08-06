import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/contacts/black_list/black_list_logic.dart';

class BlackListPage extends StatelessWidget {
  BlackListPage({super.key});

  final logic = Get.find<BlackListLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: TitleBar.back(
        title: "black_friend_list_title".tr,
      ),
      body: Padding(
        padding:  EdgeInsets.only(top: 16.w),
        child: ListView.builder(itemBuilder: (_,index) => _buildItemView(logic.blackFriendList[index]), itemCount: logic.blackFriendList.length, ),
      ),
    ));
  }

  Widget _buildItemView(ISUserInfo info) => Container(
    height: 64.h,
    color: Styles.c_FFFFFF,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              AvatarView(
                tag: info.nickname,
                url: info.faceURL,
                text: info.nickname,
              ),
              12.horizontalSpace,
              info.showName.toText
                ..style = Styles.ts_333333_16_medium
                    .adapterDark(Styles.ts_CCCCCC_16_medium),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            logic.removeBlacklist(info);
          },
          splashColor: Styles.c_0C8CE9.withOpacity(0.1),
          child: Container(
            width: 80.w,
            color: Styles.c_0C8CE9,
            child: Center(
              child: "black_friend_remove".tr.toText..style = Styles.ts_FFFFFF_14,
            ),
          ),
        )
      ],
    ),
  );
}