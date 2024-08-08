import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class ChatItemContainer extends StatelessWidget {
  const ChatItemContainer({
    super.key,
    required this.id,
    this.leftFaceUrl,
    this.rightFaceUrl,
    this.leftNickname,
    this.rightNickname,
    this.timelineStr,
    this.timeStr,
    required this.isBubbleBg,
    required this.isISend,
    required this.isSending,
    required this.isSendFailed,
    required this.isSendSucceeded,
    required this.isRead,
    this.ignorePointer = false,
    this.showLeftNickname = true,
    this.showLeftAvatar = true,
    this.showRightNickname = false,
    this.showRightAvatar = false,
    this.showTime = true,
    required this.child,
    this.sendStatusStream,
    this.onTapLeftAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onLongPressRightAvatar,
    this.onFailedToResend,
  });
  final String id;
  final String? leftFaceUrl;
  final String? rightFaceUrl;
  final String? leftNickname;
  final String? rightNickname;
  final String? timelineStr;
  final String? timeStr;
  final bool isBubbleBg;
  final bool isISend;
  final bool isRead;
  final bool isSending;
  final bool isSendFailed;
  final bool isSendSucceeded;
  final bool ignorePointer;
  final bool showLeftNickname;
  final bool showLeftAvatar;
  final bool showRightNickname;
  final bool showRightAvatar;
  final bool showTime;
  final Widget child;
  final Stream<MsgStreamEv<bool>>? sendStatusStream;
  final Function()? onTapLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onLongPressRightAvatar;
  final Function()? onFailedToResend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: ignorePointer,
        child: Column(
          children: [
            if (null != timelineStr)
              ChatTimelineView(
                timeStr: timelineStr!,
                margin: EdgeInsets.only(bottom: 20.h),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: isISend ? _buildRightView() : _buildLeftView()),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSendStatus() {
    if (isSendFailed){
      return "chat_ico_sent_fail".svg.toSvg..width = 14.w..height = 14.w;
    }else if (isSending){
      return const SizedBox(width: 14,height: 14,child: CircularProgressIndicator.adaptive());
    }else if (isSendSucceeded){
      return "chat_ico_sent_succ".svg.toSvg..width = 14.w..height = 14.w;
    }else if (isRead){
      return "chat_ico_sent_readreceipt".svg.toSvg..width = 14.w..height = 14.w;
    }
    return const SizedBox.shrink();
  }

  Widget  _buildChildView(BubbleType type) =>
      isBubbleBg ? ChatBubble(bubbleType: type, child: child) : child;

  Widget _buildLeftView() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          showLeftAvatar ?  AvatarView(
            width: 44.w,
            height: 44.h,
            textStyle: Styles.ts_FFFFFF_14_medium,
            url: leftFaceUrl,
            text: leftNickname,
            onTap: onTapLeftAvatar,
            onLongPress: onLongPressLeftAvatar,
          ) : 44.gaph,
          10.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: showTime,
                child: ChatNicknameView(
                  nickname: showLeftNickname ? leftNickname : null,
                  timeStr: showTime ? timeStr: null,
                ),
              ),
              4.verticalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildChildView(BubbleType.receiver),
                ],
              ),
            ],
          ),
        ],
      );

  Widget _buildRightView() => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: showTime,
                child: ChatNicknameView(
                  nickname: showRightNickname ? rightNickname : null,
                  timeStr: showTime ? timeStr : null,
                ),
              ),
              4.gapv,
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedSwitcher(duration: const Duration(milliseconds: 200),child: Padding(
                    padding:  EdgeInsets.only(right: 8.0.w),
                    child: _buildSendStatus(),
                  )),
                  _buildChildView(BubbleType.send),
                ],
              ),
            ],
          ),
          Visibility(visible: showTime, child: 10.gapv),
          Visibility(
            visible: showRightAvatar,
            child: AvatarView(
              width: 44.w,
              height: 44.h,
              textStyle: Styles.ts_FFFFFF_14_medium,
              url: rightFaceUrl,
              text: rightNickname,
              onTap: onTapRightAvatar,
              onLongPress: onLongPressRightAvatar,
            ),
          ),
        ],
      );
}
