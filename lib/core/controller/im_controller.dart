import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:owl_live/owl_live.dart';
import 'package:owlpro_app/core/im_callback.dart';
import 'package:owlpro_app/pages/conversation/conversation_logic.dart';

class IMController extends GetxController with IMCallback, OpenIMLive {
  late Rx<UserFullInfo> userInfo;
  late String atAllTag;

  @override
  void onClose() {
    super.close();
    super.onClose();
    onCloseLive();
  }

  @override
  void onInit() async {
    super.onInit();
    onInitLive();
    // Initialize SDK
    WidgetsBinding.instance.addPostFrameCallback((_) => initOwlIM());
  }

  void initOwlIM() async {
    final initialized = await OpenIM.iMManager.initSDK(
        platformID: IMUtils.getPlatform(),
        apiAddr: Config.imApiUrl,
        wsAddr: Config.imWsUrl,
        dataDir: Config.cachePath,
        logLevel: 6,
        logFilePath: Config.cachePath,
        listener: OnConnectListener(
          onConnecting: () {
            imSdkStatus(IMSdkStatus.connecting);
          },
          onConnectFailed: (code, error) {
            imSdkStatus(IMSdkStatus.connectionFailed);
          },
          onConnectSuccess: () {
            Logger.print("onConnectSuccess onConnectSuccess");
            imSdkStatus(IMSdkStatus.connectionSucceeded);
          },
          onKickedOffline: kickedOffline,
          onUserTokenExpired: kickedOffline,
        ));

    OpenIM.iMManager
      ..userManager.setUserListener(OnUserListener(
        onSelfInfoUpdated: (u) {
          Logger.print("onSelfInfoUpdated user = ${u.toJson()}");
          userInfo.update((val) {
            val?.nickname = u.nickname;
            val?.faceURL = u.faceURL;
            val?.remark = u.remark;
            // val?.about = u.about;
            // val?.account = u.account;
            // val?.coverURL = u.coverURL;
            val?.ex = u.ex;
            val?.globalRecvMsgOpt = u.globalRecvMsgOpt;
          });
        },
        onUserStatusChanged: userStatusChanged
      ))
      // Add message listener (remove when not in use)
      ..messageManager.setAdvancedMsgListener(OnAdvancedMsgListener(
          onRecvC2CReadReceipt: recvC2CMessageReadReceipt,
          onRecvNewMessage: (msg) {
            bool skip = false;

            if (msg.isCustomType) {
              final data = msg.customElem!.data;
              final map = jsonDecode(data!);
              final customType = map['customType'];
              if (customType == CustomMessageType.callingInvite ||
                  customType == CustomMessageType.callingAccept ||
                  customType == CustomMessageType.callingReject ||
                  customType == CustomMessageType.callingCancel ||
                  customType == CustomMessageType.callingHungup) {
                skip = true;

                final signaling = SignalingInfo(
                    invitation: InvitationInfo.fromJson(map['data']));
                signaling.userID = signaling.invitation?.inviterUserID;

                switch (customType) {
                  case CustomMessageType.callingInvite:
                    receiveNewInvitation(signaling);
                    break;
                  case CustomMessageType.callingAccept:
                    inviteeAccepted(signaling);
                    break;
                  case CustomMessageType.callingReject:
                    inviteeRejected(signaling);
                    break;
                  case CustomMessageType.callingCancel:
                    invitationCancelled(signaling);
                    break;
                  case CustomMessageType.callingHungup:
                    beHangup(signaling);
                    break;
                }
              }
            }

            if (!skip) {
              recvNewMessage(msg);
            }
          },
          onRecvGroupReadReceipt: (v) {},
          onNewRecvMessageRevoked: recvMessageRevoked))

      // Set up message sending progress listener
      ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
        onProgress: progressCallback,
      ))
      ..messageManager.setCustomBusinessListener(OnCustomBusinessListener(
        onRecvCustomBusinessMessage: recvCustomBusinessMessage,
      ))
      // Set up friend relationship listener
      ..friendshipManager.setFriendshipListener(OnFriendshipListener(
        onBlackAdded: blacklistAdded,
        onBlackDeleted: blacklistDeleted,
        onFriendApplicationAccepted: friendApplicationAccepted,
        onFriendApplicationAdded: friendApplicationAdded,
        onFriendApplicationDeleted: friendApplicationDeleted,
        onFriendApplicationRejected: friendApplicationRejected,
        onFriendInfoChanged: friendInfoChanged,
        onFriendAdded: friendAdded,
        onFriendDeleted: friendDeleted,
      ))

      // Set up conversation listener
      ..conversationManager.setConversationListener(OnConversationListener(
        onConversationChanged: conversationChanged,
        onNewConversation: newConversation,
        onTotalUnreadMessageCountChanged: totalUnreadMsgCountChanged,
        onSyncServerFailed: () {
          imSdkStatus(IMSdkStatus.syncFailed);
        },
        onSyncServerFinish: () {
          imSdkStatus(IMSdkStatus.syncEnded);
        },
        onSyncServerStart: () {
          imSdkStatus(IMSdkStatus.syncStart);
        },
      ))
      ..groupManager.setGroupListener(OnGroupListener(
        onGroupApplicationAccepted: groupApplicationAccepted,
        onGroupApplicationAdded: groupApplicationAdded,
        onGroupApplicationDeleted: groupApplicationDeleted,
        onGroupApplicationRejected: groupApplicationRejected,
        onGroupInfoChanged: groupInfoChanged,
        onGroupMemberAdded: groupMemberAdded,
        onGroupMemberDeleted: groupMemberDeleted,
        onGroupMemberInfoChanged: groupMemberInfoChanged,
        onJoinedGroupAdded: joinedGroupAdded,
        onJoinedGroupDeleted: joinedGroupDeleted,
      ));

    initializedSubject.sink.add(initialized);
  }

  Future login(String userID, String token) async {
    try {
      var user = await OpenIM.iMManager.login(
        userID: userID,
        token: token,
        defaultValue: () async => UserInfo(userID: userID),
      );
      userInfo = UserFullInfo.fromJson(user.toJson()).obs;
      _queryMyFullInfo();
      _queryAtAllTag();
    } catch (e, s) {
      Logger.print('e: $e  s:$s');
      await _handleLoginRepeatError(e);
      return Future.error(e, s);
    }
  }

  Future logout() {
    return OpenIM.iMManager.logout();
  }

  void _queryAtAllTag() async {
    atAllTag = OpenIM.iMManager.conversationManager.atAllTag;
  }

  Future<void> _queryMyFullInfo() async {
    final data = await Apis.queryMyFullInfo();
    if (data is UserFullInfo) {
      userInfo.update((val) {
        val?.allowAddFriend = data.allowAddFriend;
        val?.allowBeep = data.allowBeep;
        val?.allowVibration = data.allowVibration;
        val?.nickname = data.nickname;
        val?.faceURL = data.faceURL;
        val?.about = data.about;
        val?.address = data.address;
        val?.coverURL = data.coverURL;
        val?.publicKey = data.publicKey;
        val?.account = data.account;
      });
    }
  }

  _handleLoginRepeatError(e) async {
    if (e is PlatformException && e.code == "13002") {
      await logout();
      await DataSp.removeLoginCertificate();
    }
  }
}
