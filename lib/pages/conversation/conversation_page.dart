import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/core/controller/user_status_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sprintf/sprintf.dart';

import 'conversation_logic.dart';
import 'widgets/navbar.dart';

class ConversationPage extends StatelessWidget {
  ConversationPage({super.key});

  final imLogic = Get.find<IMController>();
  final logic = Get.find<ConversationLogic>();
  final statusLogic = Get.find<UserStatusController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: Navbar(status: logic.imStatus.value),
          body: Column(
            children: [
              24.gapv,
              logic.list.isNotEmpty
                  ? Expanded(
                      child: SlidableAutoCloseBehavior(
                      child: SmartRefresher(
                        controller: logic.refreshController,
                        header: IMViews.buildHeader(),
                        footer: IMViews.buildFooter(),
                        enablePullUp: true,
                        enablePullDown: true,
                        onRefresh: logic.onRefresh,
                        onLoading: logic.onLoading,
                        child: Column(
                          children: [
                            Visibility(
                              visible: logic.pinnedList.isNotEmpty,
                              child: SizedBox(
                                height: 72.h,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: 24.w),
                                  itemCount: logic.pinnedList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      _buildConversationPinnedItemView(
                                          logic.pinnedList.elementAt(index)),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: logic.pinnedList.isNotEmpty,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 24.w, vertical: 16.h),
                                height: 1,
                                color:
                                    Styles.c_F6F6F6.adapterDark(Styles.c_161616),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: logic.unPinnedList.length,
                                controller: logic.scrollController,
                                itemBuilder: (_, index) => AutoScrollTag(
                                  key: ValueKey(index),
                                  controller: logic.scrollController,
                                  index: index,
                                  child: _buildConversationItemView(
                                    logic.unPinnedList.elementAt(index),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                  : Expanded(
                      child: Center(
                        child: SizedBox(
                          width: 178.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              "chat_ico_empty".svg.toSvg
                                ..width = 64.w
                                ..height = 64.w
                                ..color = Styles.c_999999
                                    .adapterDark(Styles.c_333333),
                              24.gapv,
                              "chat_list_empty".tr.toText
                                ..style = Styles.ts_999999_14
                                    .adapterDark(Styles.ts_333333_14)
                                ..textAlign = TextAlign.center
                            ],
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ));
  }

  Widget _buildConversationItemView(ConversationInfo info) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.35,
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.pinConversation(info),
              flex: 2,
              padding: const EdgeInsets.all(1),
              child: Container(
                  width: 48.w,
                  height: 48.w,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                      color: Styles.c_F9F9F9.adapterDark(Styles.c_222222),
                      borderRadius: BorderRadius.circular(99999),
                      border: Border.all(
                          color: Styles.c_EDEDED.adapterDark(Styles.c_262626))),
                  child: "chat_ico_top".svg.toSvg
                    ..width = 24.w
                    ..height = 24.w
                    ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)
                    ..fit = BoxFit.cover),
            ),
            // if (logic.existUnreadMsg(info))
            //   CustomSlidableAction(
            //     onPressed: (_) => logic.markMessageHasRead(info),
            //     flex: 3,
            //     backgroundColor: Styles.c_0C8CE9,
            //     padding: const EdgeInsets.all(1),
            //     child: StrRes.markHasRead.toText
            //       ..style = Styles.ts_FFFFFF_14_medium
            //       ..maxLines = 1,
            //   ),
            CustomSlidableAction(
              onPressed: (_) => logic.deleteConversation(info),
              flex: 2,
              padding: const EdgeInsets.all(1),
              child: Container(
                  width: 48.w,
                  height: 48.w,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                      color: Styles.c_F9F9F9.adapterDark(Styles.c_222222),
                      borderRadius: BorderRadius.circular(99999),
                      border: Border.all(
                          color: Styles.c_EDEDED.adapterDark(Styles.c_262626))),
                  child: "chat_ico_delete".svg.toSvg
                    ..width = 24.w
                    ..height = 24.w
                    ..fit = BoxFit.cover),
            ),
          ],
        ),
        child: _buildItemView(info),
      );

  Widget _buildItemView(ConversationInfo info) => Ink(
        child: InkWell(
          onTap: () => logic.toChat(conversationInfo: info),
          child: Container(
            // height: 50.h,
            margin: EdgeInsets.only(bottom: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                AvatarView(
                  width: 48.w,
                  height: 48.h,
                  text: logic.getShowName(info),
                  url: info.faceURL,
                  online: statusLogic.getOnline(info.userID!),
                ),
                12.gaph,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 180.w),
                            child: logic.getShowName(info).toText
                              ..style = Styles.ts_333333_14_medium
                                  .adapterDark(Styles.ts_CCCCCC_14_medium)
                              ..maxLines = 1
                              ..overflow = TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          logic.getTime(info).toText
                            ..style = Styles.ts_999999_12
                                .adapterDark(Styles.ts_555555_12),
                        ],
                      ),
                      5.verticalSpace,
                      Row(
                        children: [
                          MatchTextView(
                            text: logic.getContent(info),
                            textStyle: Styles.ts_999999_12
                                .adapterDark(Styles.ts_666666_12),
                            allAtMap: logic.getAtUserMap(info),
                            prefixSpan: TextSpan(
                              text: '',
                              children: [
                                if (logic.isNotDisturb(info) &&
                                    logic.getUnreadCount(info) > 0)
                                  TextSpan(
                                    text: '[${sprintf(StrRes.nPieces, [
                                          logic.getUnreadCount(info)
                                        ])}] ',
                                    style: Styles.ts_0C8CE9_10_bold,
                                  ),
                                TextSpan(
                                  text: logic.getPrefixTag(info),
                                  style: Styles.ts_0C8CE9_14_bold,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            patterns: <MatchPattern>[
                              MatchPattern(
                                type: PatternType.at,
                                style: Styles.ts_0C8CE9_14_bold,
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (logic.isNotDisturb(info))
                            "chat_ico_remind_not".svg.toSvg
                              ..width = 12.w
                              ..height = 12.h
                              ..color =
                                  Styles.c_999999.adapterDark(Styles.c_666666)
                          else
                            UnreadCountView(count: logic.getUnreadCount(info)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildConversationPinnedItemView(ConversationInfo info) =>
      GestureDetector(
        onTap: () => logic.toChat(conversationInfo: info),
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  AvatarView(
                    width: 48.w,
                    height: 48.h,
                    text: logic.getShowName(info),
                    url: info.faceURL,
                    online: statusLogic.getOnline(info.userID!),
                  ),
                  Positioned(
                      right: 0.w,
                      top: 0.h,
                      child: UnreadCountView(
                        count: logic.getUnreadCount(info),
                        color: logic.isNotDisturb(info)
                            ? Styles.c_999999
                            : Styles.c_DE473E,
                        borderColor: Styles.c_FFFFFF,
                      ))
                ],
              ),
              6.gapv,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 80.w),
                child: logic.getShowName(info).toText
                  ..style = Styles.ts_666666_12.adapterDark(Styles.ts_999999_12)
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
