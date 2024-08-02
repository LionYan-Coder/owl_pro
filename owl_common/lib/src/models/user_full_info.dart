import 'package:owl_common/owl_common.dart';
import 'package:owl_common/src/models/google_time.dart';

class UserFullInfo {
  String? userID;
  String? nickname;
  String? remark;
  String? faceURL;
  String? account;
  String? about;
  String? address;
  String? coverURL;
  String? publicKey;
  int? order;
  int? status;
  int? allowAddFriend;
  int? allowBeep;
  int? allowVibration;
  int? forbidden;
  String? ex;
  String? station;
  int? globalRecvMsgOpt;
  bool isFriendship = false;
  bool isBlacklist = false;
  List<DepartmentInfo>? departmentList;
  dynamic createTime;

  String get showName => remark?.isNotEmpty == true
      ? remark!
      : (nickname?.isNotEmpty == true ? nickname! : account!);

  UserFullInfo({
    this.userID,
    this.nickname,
    this.faceURL,
    this.account,
    this.address,
    this.publicKey,
    this.about,
    this.coverURL,
    this.remark,
    this.order,
    this.status,
    this.allowAddFriend,
    this.allowBeep,
    this.allowVibration,
    this.forbidden,
    this.station,
    this.ex,
    this.createTime,
    this.globalRecvMsgOpt,
    this.isFriendship = false,
    this.isBlacklist = false,
    this.departmentList,
  });

  UserFullInfo.fromJson(Map<String, dynamic> json) {
    var c_time = null;
    if (json['createTime'] != null) {
      if (json['createTime'].runtimeType == int) {
        c_time = json['createTime'];
      } else {
        c_time = GoogleTime.fromJson(json['createTime']);
      }
    }
    userID = json['userID'];
    nickname = json['nickname'];
    faceURL = json['faceURL'];
    account = json['account'];
    publicKey = json['publicKey'];
    about = json['about'];
    coverURL = json['coverURL'];
    address = json['address'];
    createTime = c_time;
    order = json['order'];
    status = json['status'];
    allowAddFriend = json['allowAddFriend'];
    allowBeep = json['allowBeep'];
    allowVibration = json['allowVibration'];
    forbidden = json['forbidden'];
    station = json['station'];
    ex = json['ex'];
    globalRecvMsgOpt = json['globalRecvMsgOpt'];
    isFriendship = json['isFriendship'] ?? true;
    isBlacklist = json['isBlacklist'] ?? false;
    departmentList = json['departmentList'] == null
        ? null
        : (json['departmentList'] as List)
            .map((e) => DepartmentInfo.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['userID'] = userID;
    data['nickname'] = nickname;
    data['remark'] = remark;
    data['faceURL'] = faceURL;
    data['address'] = address;
    data['account'] = account;
    data['publicKey'] = publicKey;
    data['about'] = about;
    data['coverURL'] = coverURL;
    data['order'] = order;
    data['status'] = status;
    data['createTime'] =
        createTime.runtimeType == int ? createTime : createTime?.toJson();
    data['allowAddFriend'] = allowAddFriend;
    data['allowBeep'] = allowBeep;
    data['allowVibration'] = allowVibration;
    data['forbidden'] = forbidden;
    data['station'] = station;
    data['ex'] = ex;
    data['globalRecvMsgOpt'] = globalRecvMsgOpt;
    data['isFriendship'] = isFriendship;
    data['isBlacklist'] = isBlacklist;
    data['departmentList'] = departmentList?.map((e) => e.toJson()).toList();
    return data;
  }
}

class DepartmentInfo {
  String? departmentID;
  String? departmentFaceURL;
  String? departmentName;
  String? departmentParentID;
  int? departmentOrder;
  int? departmentDepartmentType;
  String? departmentRelatedGroupID;
  int? departmentCreateTime;
  int? memberOrder;
  String? memberPosition;
  int? memberLeader;
  int? memberStatus;
  int? memberEntryTime;
  int? memberTerminationTime;
  int? memberCreateTime;

  DepartmentInfo(
      {this.departmentID,
      this.departmentFaceURL,
      this.departmentName,
      this.departmentParentID,
      this.departmentOrder,
      this.departmentDepartmentType,
      this.departmentRelatedGroupID,
      this.departmentCreateTime,
      this.memberOrder,
      this.memberPosition,
      this.memberLeader,
      this.memberStatus,
      this.memberEntryTime,
      this.memberTerminationTime,
      this.memberCreateTime});

  DepartmentInfo.fromJson(Map<String, dynamic> json) {
    departmentID = json['departmentID'];
    departmentFaceURL = json['departmentFaceURL'];
    departmentName = json['departmentName'];
    departmentParentID = json['departmentParentID'];
    departmentOrder = json['departmentOrder'];
    departmentDepartmentType = json['departmentDepartmentType'];
    departmentRelatedGroupID = json['departmentRelatedGroupID'];
    departmentCreateTime = json['departmentCreateTime'];
    memberOrder = json['memberOrder'];
    memberPosition = json['memberPosition'];
    memberLeader = json['memberLeader'];
    memberStatus = json['memberStatus'];
    memberEntryTime = json['memberEntryTime'];
    memberTerminationTime = json['memberTerminationTime'];
    memberCreateTime = json['memberCreateTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['departmentID'] = departmentID;
    data['departmentFaceURL'] = departmentFaceURL;
    data['departmentName'] = departmentName;
    data['departmentParentID'] = departmentParentID;
    data['departmentOrder'] = departmentOrder;
    data['departmentDepartmentType'] = departmentDepartmentType;
    data['departmentRelatedGroupID'] = departmentRelatedGroupID;
    data['departmentCreateTime'] = departmentCreateTime;
    data['memberOrder'] = memberOrder;
    data['memberPosition'] = memberPosition;
    data['memberLeader'] = memberLeader;
    data['memberStatus'] = memberStatus;
    data['memberEntryTime'] = memberEntryTime;
    data['memberTerminationTime'] = memberTerminationTime;
    data['memberCreateTime'] = memberCreateTime;
    return data;
  }
}
