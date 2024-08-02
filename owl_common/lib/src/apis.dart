import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';

class Apis {
  static Options get imTokenOptions =>
      Options(headers: {'token': DataSp.imToken});

  static Options get chatTokenOptions =>
      Options(headers: {'token': DataSp.chatToken});

  static Future<LoginCertificate> login({
    required String address,
    required String nonce,
    required String sign,
  }) async {
    try {
      var data = await HttpUtil.post(Urls.login,
          data: {
            "address": address,
            "nonce": nonce,
            "signature": sign,
            'platform': IMUtils.getPlatform(),
          },
          showErrorToast: false);
      return LoginCertificate.fromJson(data!);
    } catch (e, s) {
      Logger.print('e:$e s:$s');
      return Future.error(e);
    }
  }

  static Future<LoginCertificate> register({
    required String nickname,
    required String account,
    required String address,
    required String publicKey,
    required String faceURL,
    required String nonce,
    required String sign,
    String? about,
  }) async {
    try {
      var data = await HttpUtil.post(Urls.register, data: {
        'deviceID': DataSp.getDeviceID(),
        'platform': IMUtils.getPlatform(),
        "nonce": nonce,
        "signature": sign,
        'autoLogin': true,
        'user': {
          "nickname": nickname,
          "account": account,
          "about": about,
          "address": address,
          "publicKey": publicKey,
          "faceURL": faceURL,
        },
      });
      return LoginCertificate.fromJson(data!);
    } catch (e, s) {
      Logger.print('e:$e s:$s');
      return Future.error(e);
    }
  }

  static Future<ChallengeNonce> challenge({required String publicKey}) async {
    try {
      var data =
          await HttpUtil.post(Urls.challenge, data: {"publicKey": publicKey});

      return ChallengeNonce.fromJson(data!);
    } catch (e, s) {
      Logger.print('e:$e s:$s');
      return Future.error(e);
    }
  }

  static Future<dynamic> updateUserInfo({
    required String userID,
    String? account,
    String? nickname,
    String? faceURL,
    String? coverURL,
    String? about,
  }) async {
    Map<String, dynamic> param = {'userID': userID};
    void put(String key, dynamic value) {
      if (null != value) {
        param[key] = value;
      }
    }

    put('account', account);
    put('nickname', nickname);
    put('faceURL', faceURL);
    put('coverURL', coverURL ?? '');
    put('about', about ?? '');

    return HttpUtil.post(
      Urls.updateUserInfo,
      data: {
        ...param,
        'platform': IMUtils.getPlatform(),
        // 'operationID': operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<UserFullInfo> searchUserByAccountOrAddress({
    String address = "",
    String account = "",
  }) async {
    final data = await HttpUtil.post(Urls.searchUserByAccountOrAddress,
        data: {'address': address, "account": account},
        options: chatTokenOptions,
        showErrorToast: false);
    var user = data["user"];
    return UserFullInfo.fromJson(user);
  }

  static Future<List<FriendInfo>> searchFriendInfo(
    String keyword, {
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    final data = await HttpUtil.post(
      Urls.searchFriendInfo,
      data: {
        'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
        'keyword': keyword,
      },
      options: chatTokenOptions,
    );
    if (data['users'] is List) {
      return (data['users'] as List)
          .map((e) => FriendInfo.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<List<UserFullInfo>?> getUserFullInfo({
    int pageNumber = 1,
    int showNumber = 10,
    required List<String> userIDList,
  }) async {
    final data = await HttpUtil.post(
      Urls.getUsersFullInfo,
      data: {
        'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
        'userIDs': userIDList,
        'platform': IMUtils.getPlatform(),
      },
      options: chatTokenOptions,
    );
    if (data['users'] is List) {
      return (data['users'] as List)
          .map((e) => UserFullInfo.fromJson(e))
          .toList();
    }
    return null;
  }

  static Future<List<UserFullInfo>?> searchUserFullInfo({
    required String content,
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    final data = await HttpUtil.post(
      Urls.searchUserFullInfo,
      data: {
        'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
        'keyword': content,
      },
      options: chatTokenOptions,
    );
    if (data['users'] is List) {
      return (data['users'] as List)
          .map((e) => UserFullInfo.fromJson(e))
          .toList();
    }
    return null;
  }

  static Future<UserFullInfo?> queryMyFullInfo() async {
    final list = await Apis.getUserFullInfo(
      userIDList: [OwlIM.iMManager.userID],
    );
    return list?.firstOrNull;
  }

  static Future<UserFullInfo> getUserInfoOfB({
    required String userID,
  }) async {
    final data = await HttpUtil.post(
      Urls.queryUserInfo,
      showErrorToast: false,
      data: {'userID': userID},
      options: chatTokenOptions,
    );
    return UserFullInfo.fromJson(data);
  }

  static Future<bool> requestVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) async {
    return HttpUtil.post(
      Urls.getVerificationCode,
      data: {
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
        "email": email,
        'usedFor': usedFor,
        'invitationCode': invitationCode
      },
    ).then((value) {
      IMViews.showToast(StrRes.sentSuccessfully);
      return true;
    }).catchError((e, s) {
      Logger.print('e:$e s:$s');
      return false;
    });
  }

  static Future<SignalingCertificate> getTokenForRTC(
      String roomID, String userID) async {
    return HttpUtil.post(
      Urls.getTokenForRTC,
      data: {
        "room": roomID,
        "identity": userID,
      },
      options: chatTokenOptions,
    ).then((value) {
      final signaling = SignalingCertificate.fromJson(value)..roomID = roomID;
      return signaling;
    }).catchError((e, s) {
      Logger.print('e:$e s:$s');
    });
  }

  static Future<dynamic> checkVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verificationCode,
    required int usedFor,
    String? invitationCode,
  }) {
    return HttpUtil.post(
      Urls.checkVerificationCode,
      data: {
        "phoneNumber": phoneNumber,
        "areaCode": areaCode,
        "email": email,
        "verifyCode": verificationCode,
        "usedFor": usedFor,
        'invitationCode': invitationCode
      },
    );
  }

  static Future<UpgradeInfoV2> checkUpgradeV2() {
    return dio.post<Map<String, dynamic>>(
      '',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
      data: {
        '_api_key': '',
        'appKey': '',
      },
    ).then((resp) {
      Map<String, dynamic> map = resp.data!;
      if (map['code'] == 0) {
        return UpgradeInfoV2.fromJson(map['data']);
      }
      return Future.error(map);
    });
  }

  static _handleStatus(
    List<OnlineStatus> list, {
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) {
    final statusDesc = <String, String>{};
    final status = <String, bool>{};
    for (var e in list) {
      if (e.status == 'online') {
        final pList = <String>[];
        for (var platform in e.detailPlatformStatus!) {
          if (platform.platform == "Android" || platform.platform == "IOS") {
            pList.add(StrRes.phoneOnline);
          } else if (platform.platform == "Windows") {
            pList.add(StrRes.pcOnline);
          } else if (platform.platform == "Web") {
            pList.add(StrRes.webOnline);
          } else if (platform.platform == "MiniWeb") {
            pList.add(StrRes.webMiniOnline);
          } else {
            statusDesc[e.userID!] = StrRes.online;
          }
        }
        statusDesc[e.userID!] = '${pList.join('/')}${StrRes.online}';
        status[e.userID!] = true;
      } else {
        statusDesc[e.userID!] = StrRes.offline;
        status[e.userID!] = false;
      }
    }
    onlineStatusDescCallback?.call(statusDesc);
    onlineStatusCallback?.call(status);
  }
}
