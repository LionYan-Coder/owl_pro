import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owlpro_app/pages/contacts/new_friend/new_friend_logic.dart';

class NewFriendPage extends StatelessWidget {
  NewFriendPage({super.key});

  final logic = Get.find<NewFriendLogic>();

  @override
  Widget build(BuildContext context) {
    bool oneWeekLabelAdded = false;
    return Scaffold(
      appBar: TitleBar.back(
        title: "contact_new_friend_title".tr,
        right: Row(
          children: [
            AnimatedOpacity(
              opacity: logic.applicationList.isEmpty ? 0.3 : 1,
              duration: const Duration(milliseconds: 250),
              child: IgnorePointer(
                ignoring: logic.applicationList.isEmpty,
                child: TextButton(
                    onPressed: () {},
                    child: "contact_new_friend_clear".tr.toText
                      ..style =
                          Styles.ts_666666_14.adapterDark(Styles.ts_CCCCCC_14)),
              ),
            ),
            8.gaph
          ],
        ),
      ),
      body: Obx(() => ListView.custom(
            padding: const EdgeInsets.symmetric(vertical: 24).w,
            childrenDelegate: SliverChildBuilderDelegate((context, index) {
              final createTime = DateTime.fromMillisecondsSinceEpoch(
                  logic.applicationList[index].createTime ?? 0);
              // 判断是否是一周前的数据
              bool isOneWeekOld =
                  DateTime.now().difference(createTime).inDays >= 7;
              if (isOneWeekOld && !oneWeekLabelAdded) {
                return Column(
                  children: [
                    Visibility(
                      visible: index > 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Container(
                          height: 1,
                          color: Styles.c_F6F6F6.adapterDark(Styles.c_161616),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 24.w),
                      child: "one_week_before".tr.toText
                        ..style = Styles.ts_666666_12,
                    ),
                    _buildItemView(logic.applicationList[index])
                  ],
                );
              }
              return _buildItemView(logic.applicationList[index]);
            }, childCount: logic.applicationList.length),
          )),
    );
  }

  Widget _buildItemView(FriendApplicationInfo info) {
    final isSend = logic.isISendRequest(info);
    String? name = isSend ? info.toNickname : info.fromNickname;
    String? faceURL = isSend ? info.toFaceURL : info.fromFaceURL;
    String? reason = info.reqMsg;
    return Container(
      margin: EdgeInsets.only(bottom: 16.w),
      child: Slidable(
        endActionPane: ActionPane(
            extentRatio: 0.20,
            motion: const DrawerMotion(),
            children: [
              CustomSlidableAction(
                padding: EdgeInsets.zero,
                onPressed: (context) {
                  // _contactNewFriendController
                  //     .deleteRequestFriendById(newFriend.ID);
                },
                child: Container(
                    width: 48.w,
                    height: 48.w,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                        color: Styles.c_F9F9F9.adapterDark(Styles.c_222222),
                        borderRadius: BorderRadius.circular(99999),
                        border: Border.all(
                            color:
                                Styles.c_EDEDED.adapterDark(Styles.c_262626))),
                    child: "chat_ico_delete".svg.toSvg
                      ..width = 24.w
                      ..height = 24.w
                      ..fit = BoxFit.cover),
              )
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarView(url: faceURL, radius: 24, text: name),
                    12.gaph,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (name ?? '').toText
                          ..style = Styles.ts_666666_16_medium
                              .adapterDark(Styles.ts_CCCCCC_16_medium),
                        4.gapv,
                        SizedBox(
                            width: 154.w,
                            child:
                                ("${"contact_new_friend_message_prefix".tr}$reason")
                                    .toText
                                  ..style = Styles.ts_999999_14
                                      .adapterDark(Styles.ts_666666_14))
                      ],
                    ),
                  ],
                ),
              ),
              (!isSend && info.handleResult == 0)
                  ? _acceptAndReject(info)
                  : _requestStatus(info)
            ],
          ),
        ),
      ),
    );
  }

  Widget _acceptAndReject(FriendApplicationInfo info) {
    return Row(
      children: [
        "accept".tr.toButton
          ..onPressed = () {
            logic.acceptFriendApplication(info);
          }
          ..textStyle = Styles.ts_FFFFFF_12
          ..borderRadius = 4
          ..height = 24.w
          ..width = 44.w,
        8.gaph,
        "reject".tr.toButton
          ..onPressed = () {
            logic.refuseFriendApplication(info);
          }
          ..textStyle = Styles.ts_FFFFFF_12
          ..borderRadius = 4
          ..height = 24.w
          ..width = 44.w,
      ],
    );
  }

  Widget _requestStatus(FriendApplicationInfo info) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5).w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: Styles.c_F9F9F9.adapterDark(Styles.c_121212),
            border: Border.all(
                color: Styles.c_EDEDED.adapterDark(Styles.c_262626))),
        child: logic.status(info).tr.toText
          ..style = Styles.ts_999999_12_medium
              .adapterDark(Styles.ts_666666_12_medium));
  }
}
