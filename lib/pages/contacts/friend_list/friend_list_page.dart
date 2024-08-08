import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/user_status_controller.dart';
import 'package:owlpro_app/pages/contacts/contact_logic.dart';
import 'package:owlpro_app/pages/contacts/friend_list/friend_list_logic.dart';
import 'package:owlpro_app/pages/contacts/widgets/contact_menu.dart';

class FriendListPage extends StatelessWidget {
  FriendListPage({super.key});

  final logic = Get.find<FriendListLogic>();
  final statusLogic =  Get.find<UserStatusController>();
  final contactLogic = Get.find<ContactLogic>();

  @override
  Widget build(BuildContext context) {

    return Obx(
      () {
        return WrapAzListView<ISUserInfo>(
          data: logic.friendList,
          itemCount: logic.friendList.length ,
          itemBuilder: (_, data, index) {
            if (index == 0) {
              return ContactMenus();
            } else {
              return _buildItemView(data);
            }
          },
        );
      },
    );
  }

  Widget _buildItemView(ISUserInfo info) => Ink(
        height: 64.h,
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: () => contactLogic.viewUserProfile(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                AvatarView(
                  tag: info.nickname,
                  url: info.faceURL,
                  text: info.nickname,
                  online: statusLogic.getOnline(info.userID!),
                ),
                12.horizontalSpace,
                info.showName.toText
                  ..style = Styles.ts_333333_16_medium
                      .adapterDark(Styles.ts_CCCCCC_16_medium),
              ],
            ),
          ),
        ),
      );
}
