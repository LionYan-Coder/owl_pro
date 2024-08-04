import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sprintf/sprintf.dart';

import 'conversation_logic.dart';
import 'widgets/navbar.dart';

class ConversationPage extends StatelessWidget {
  ConversationPage({super.key});

  final imLogic = Get.find<IMController>();
  final logic = Get.find<ConversationLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Navbar(),
        Expanded(
            child: SlidableAutoCloseBehavior(
          child: SmartRefresher(
            controller: logic.refreshController,
            header: IMViews.buildHeader(),
            footer: IMViews.buildFooter(),
            enablePullUp: true,
            enablePullDown: true,
            onRefresh: logic.onRefresh,
            onLoading: logic.onLoading,
            child: ListView.builder(
              itemCount: logic.list.length,
              controller: logic.scrollController,
              itemBuilder: (_, index) => AutoScrollTag(
                key: ValueKey(index),
                controller: logic.scrollController,
                index: index,
                child: _buildConversationItemView(
                  logic.list.elementAt(index),
                ),
              ),
            ),
          ),
        ))
      ],
    );
  }

  Widget _buildConversationItemView(ConversationInfo info) => Slidable(

        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: logic.existUnreadMsg(info)
              ? 0.7
              : (logic.isPinned(info) ? 0.5 : 0.4),
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.pinConversation(info),
              flex: logic.isPinned(info) ? 3 : 2,
              backgroundColor: Styles.c_121212,
              padding: const EdgeInsets.all(1),
              child:
                  (logic.isPinned(info) ? StrRes.cancelTop : StrRes.top).toText
                    ..style = Styles.ts_FFFFFF_14_medium,
            ),
            if (logic.existUnreadMsg(info))
              CustomSlidableAction(
                onPressed: (_) => logic.markMessageHasRead(info),
                flex: 3,
                backgroundColor: Styles.c_0C8CE9,
                padding: const EdgeInsets.all(1),
                child: StrRes.markHasRead.toText
                  ..style = Styles.ts_FFFFFF_14_medium
                  ..maxLines = 1,
              ),
            CustomSlidableAction(
              onPressed: (_) => logic.deleteConversation(info),
              flex: 2,
              backgroundColor: Styles.c_0C8CE9,
              padding: const EdgeInsets.all(1),
              child: StrRes.delete.toText..style = Styles.ts_FFFFFF_14_medium,
            ),
          ],
        ),
        child: _buildItemView(info),
      );

  Widget _buildItemView(ConversationInfo info) => Ink(
        child: InkWell(
          onTap: () => logic.toChat(conversationInfo: info),
          child: Stack(
            children: [
              Container(
                height: 50.h,
                margin: EdgeInsets.symmetric(vertical: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    AvatarView(
                      width: 48.w,
                      height: 48.h,
                      text: logic.getShowName(info),
                      url: info.faceURL,
                      isGroup: logic.isGroupChat(info),
                      textStyle: Styles.ts_FFFFFF_14_medium.adapterDark(Styles.ts_333333_14_medium),
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
                                  ..style = Styles.ts_333333_14_medium.adapterDark(Styles.ts_CCCCCC_14_medium)
                                  ..maxLines = 1
                                  ..overflow = TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              logic.getTime(info).toText
                                ..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
                            ],
                          ),
                          5.verticalSpace,
                          Row(
                            children: [
                              MatchTextView(
                                text: logic.getContent(info),
                                textStyle: Styles.ts_999999_12.adapterDark(Styles.ts_666666_12),
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
                                ImageRes.notDisturb.toImage
                                  ..width = 13.63.w
                                  ..height = 14.07.h
                              else
                                UnreadCountView(
                                    count: logic.getUnreadCount(info)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
