import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:owlpro_app/pages/chat/widgets/user_network_status.dart';
import 'chat_logic.dart';
import 'widgets/navbar.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>(tag: GetTags.chat);

  ChatPage({super.key});

  Widget _buildItemView(Message message,Message? prevMessage) {
    final hiddenTime = logic.hiddenTime(message, prevMessage);
    final hiddenAvatar  = logic.hiddenAvatar(message, prevMessage);
    return ChatItemView(
      key: logic.itemKey(message),
      message: message,
      allAtMap: logic.getAtMapping(message),
      // timelineStr: logic.getShowTime(message),
      sendStatusSubject: logic.sendStatusSub,
      sendProgressSubject: logic.sendProgressSub,
      leftNickname: logic.getNewestNickname(message),
      leftFaceUrl: logic.getNewestFaceURL(message),
      // rightNickname: OwlIM.iMManager.userInfo.nickname,
      // rightFaceUrl: OwlIM.iMManager.userInfo.faceURL,
      showLeftNickname: logic.isGroupChat,
      showLeftAvatar: !hiddenTime,
      showRightNickname: false,
      showTime: !hiddenTime,
      onFailedToResend: () => logic.failedResend(message),
      onClickItemView: () => logic.parseClickEvent(message),
      onLongPressLeftAvatar: () {
        logic.onLongPressLeftAvatar(message);
      },
      onLongPressRightAvatar: () {},
      onTapLeftAvatar: () {
        logic.onTapLeftAvatar(message);
      },
      // onTapRightAvatar: logic.onTapRightAvatar,
      onVisibleTrulyText: (text) {},
      customTypeBuilder: _buildCustomTypeItemView,
    );
  }

  CustomTypeInfo? _buildCustomTypeItemView(_, Message message) {
    final data = IMUtils.parseCustomMessage(message);
    if (null != data) {
      final viewType = data['viewType'];
      if (viewType == CustomMessageType.call) {
        final type = data['type'];
        final content = data['content'];
        final view = ChatCallItemView(type: type, content: content);
        return CustomTypeInfo(view);
      } else if (viewType == CustomMessageType.deletedByFriend || viewType == CustomMessageType.blockedByFriend) {
        final view = ChatFriendRelationshipAbnormalHintView(
          name: logic.nickname.value,
          blockedByFriend: viewType == CustomMessageType.blockedByFriend,
          deletedByFriend: viewType == CustomMessageType.deletedByFriend,
        );
        return CustomTypeInfo(view, false, false);
      } else if (viewType == CustomMessageType.removedFromGroup) {
        return CustomTypeInfo(
          StrRes.removedFromGroupHint.toText..style = Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
          false,
          false,
        );
      } else if (viewType == CustomMessageType.groupDisbanded) {
        return CustomTypeInfo(
          StrRes.groupDisbanded.toText..style = Styles.ts_666666_12,
          false,
          false,
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: ChatNavbar(
        height: 56.h,
        left: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              IconButton(onPressed: () => Get.back(), icon:  "nvbar_ico_back".svg.toSvg
                ..width = 24.w
                ..height = 24.h
                ..color =
                    Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
            8.gaph,
            AvatarView(
              radius: 20.r,
              text: logic.nickname.value,
              url: logic.faceUrl.value,
            ),
            8.gaph,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logic.nickname.value.toText..style = Styles.ts_333333_14_medium.adapterDark(Styles.ts_CCCCCC_14_medium),
                2.gapv,
                UserOnlineStatus()
              ],
            )
          ],
        ),
        right: Row(
          children: [
            IconButton(onPressed: () {}, icon: "nvbar_ico_fire_phone".svg.toSvg..width = 24.w..height = 24.w..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
            16.gaph
          ],
        ),
      ),
      body: ChatListView(
        itemCount: logic.messageList.length,
        controller: logic.scrollController,
        onScrollToBottomLoad: logic.onScrollToBottomLoad,
        onScrollToTop: logic.onScrollToTop,
        itemBuilder: (_, index) {
          final message = logic.indexOfMessage(index);
          final prevMessage = logic.messageList.reversed.elementAtOrNull(index + 1);
          return _buildItemView(message,prevMessage);
        },
      ),
      bottomNavigationBar: ChatInputBox(
        allAtMap: logic.atUserNameMappingMap,
        controller: logic.inputCtrl,
        focusNode: logic.focusNode,
        isNotInGroup: logic.isInvalidGroup,
        onSend: (v) => logic.sendTextMsg(),
        onSendVoice: (_,videoPath) => logic.sendVoice(videoPath: videoPath, duration: 60),
        hintText: "chat_input_hint".tr,
        // toolbox: ChatToolBox(
        //   onTapAlbum: logic.onTapAlbum,
        //   onTapCamera: logic.onTapCamera,
        //   onTapCall: logic.call,
        // ),
      ),
    ));
  }
}
