import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class SignalingInfo {
  String? userID;

  InvitationInfo? invitation;

  OfflinePushInfo? offlinePushInfo;

  SignalingInfo({
    this.userID,
    this.invitation,
    this.offlinePushInfo,
  });

  SignalingInfo.fromJson(Map<String, dynamic> json) {
    invitation = json['invitation'] == null
        ? null
        : InvitationInfo.fromJson(json['invitation']);
    offlinePushInfo = json['offlinePushInfo'] == null
        ? null
        : OfflinePushInfo.fromJson(json['offlinePushInfo']);
    userID = json['userID'] ?? invitation?.inviterUserID;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['invitation'] = invitation?.toJson();
    data['offlinePushInfo'] = offlinePushInfo?.toJson();
    return data;
  }
}

class InvitationInfo {
  String? inviterUserID;

  List<String>? inviteeUserIDList;

  String? groupID;

  String? roomID;

  int? timeout;

  String? mediaType;

  int? sessionType;

  int? platformID;

  InvitationInfo(
      {this.inviterUserID,
      this.inviteeUserIDList,
      this.groupID,
      this.roomID,
      this.timeout,
      this.mediaType,
      this.sessionType,
      this.platformID});

  InvitationInfo.fromJson(Map<String, dynamic> json) {
    inviterUserID = json['inviterUserID'];
    inviteeUserIDList = json['inviteeUserIDList']?.cast<String>();
    groupID = json['groupID'];
    roomID = json['roomID'];
    timeout = json['timeout'];
    mediaType = json['mediaType'];
    sessionType = json['sessionType'];
    platformID = json['platformID'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['inviterUserID'] = inviterUserID;
    data['inviteeUserIDList'] = inviteeUserIDList;
    data['groupID'] = groupID;
    data['roomID'] = roomID;
    data['timeout'] = timeout;
    data['mediaType'] = mediaType;
    data['sessionType'] = sessionType;
    data['platformID'] = platformID;
    return data;
  }
}

class SignalingCertificate {
  String? token;

  String? roomID;

  String? liveURL;

  List<String>? busyLineUserIDList;

  SignalingCertificate({
    this.token,
    this.roomID,
    this.liveURL,
    this.busyLineUserIDList,
  });

  SignalingCertificate.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    roomID = json['roomID'];
    liveURL = json['serverUrl'];
    busyLineUserIDList = json['busyLineUserIDList']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['roomID'] = roomID;
    data['serverUrl'] = liveURL;
    data['busyLineUserIDList'] = busyLineUserIDList;
    return data;
  }
}

class RoomCallingInfo {
  InvitationInfo? invitation;
  List<Participant>? participant;
  String? roomID;
  String? token;
  String? liveURL;
  String? groupID;

  RoomCallingInfo({
    this.invitation,
    this.participant,
    this.roomID,
    this.token,
    this.liveURL,
    this.groupID,
  });

  RoomCallingInfo.fromJson(Map<String, dynamic> json) {
    invitation = json['invitation'] != null
        ? InvitationInfo.fromJson(json['invitation'])
        : null;
    if (json['participant'] != null) {
      participant = <Participant>[];
      json['participant'].forEach((v) {
        participant!.add(Participant.fromJson(v));
      });
    }
    roomID = json['roomID'] ?? invitation?.roomID;
    token = json['token'];
    liveURL = json['liveURL'];
    groupID = json['groupID'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (invitation != null) {
      data['invitation'] = invitation!.toJson();
    }
    if (participant != null) {
      data['participant'] = participant!.map((v) => v.toJson()).toList();
    }
    data['roomID'] = roomID;
    data['token'] = token;
    data['liveURL'] = liveURL;
    data['groupID'] = groupID;
    return data;
  }
}

class Participant {
  GroupInfo? groupInfo;
  GroupMembersInfo? groupMemberInfo;
  UserInfo? userInfo;

  Participant({this.groupInfo, this.groupMemberInfo, this.userInfo});

  Participant.fromJson(Map<String, dynamic> json) {
    groupInfo = json['groupInfo'] != null
        ? GroupInfo.fromJson(json['groupInfo'])
        : null;
    groupMemberInfo = json['groupMemberInfo'] != null
        ? GroupMembersInfo.fromJson(json['groupMemberInfo'])
        : null;
    userInfo =
        json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (groupInfo != null) {
      data['groupInfo'] = groupInfo!.toJson();
    }
    if (groupMemberInfo != null) {
      data['groupMemberInfo'] = groupMemberInfo!.toJson();
    }
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    return data;
  }
}

class CustomSignaling {
  String? roomID;
  String? customInfo;

  CustomSignaling({this.roomID, this.customInfo});

  CustomSignaling.fromJson(Map<String, dynamic> json) {
    roomID = json['roomID'];
    customInfo = json['customInfo'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['roomID'] = roomID;
    data['customInfo'] = customInfo;
    return data;
  }
}
