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
  final statusLogic = Get.find<UserStatusController>();
  final contactLogic = Get.find<ContactLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return logic.friendList.length > 1
            ? WrapAzListView<ISUserInfo>(
                data: logic.friendList,
                itemCount: logic.friendList.length,
                itemBuilder: (_, data, index) {
                  if (index == 0) {
                    return ContactMenus();
                  } else {
                    return _buildItemView(data);
                  }
                },
              )
            : Column(
              children: [
              ContactMenus(),
                Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 178.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            "chat_ico_newfirend".svg.toSvg..width=  64.w..height = 64.w..color = Styles.c_999999.adapterDark(Styles.c_333333),
                            24.gapv,
                            "contact_empty".tr.toText..style = Styles.ts_999999_14.adapterDark(Styles.ts_333333_14)..textAlign = TextAlign.center
                          ],
                        ),
                      )
                    ),
                  ),
              ],
            );
      },
    );
  }

  Widget _buildItemView(ISUserInfo info) => Ink(
        height: 64.h,
        color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        child: InkWell(
          onTap: () => contactLogic.viewUserProfile(
              info.userID!, info.nickname, info.faceURL),
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
