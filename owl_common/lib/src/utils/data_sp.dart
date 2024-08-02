import 'package:flutter/material.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_im_sdk/owl_im_sdk.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class DataSp {
  static const _isInit = 'isInit';
  static const _loginCertificate = 'loginCertificate';
  static const _accounts = 'userIds';
  static const _server = "server";
  static const _ip = 'ip';
  static const _deviceID = 'deviceID';
  static const _devicePassword = 'devicePassword';
  static const _lastVerifyPwdTime = 'lastVerifyPwdTime';
  static const _verifyPwdGap = 'verifyPwdGap';
  static const _language = "language";
  static const _appTheme = 'appTheme';
  static const _groupApplication = "%s_groupApplication";
  static const _friendApplication = "%s_friendApplication";
  static const _ignoreUpdate = 'ignoreUpdate';
  // static const _enabledVibration = 'enabledVibration';
  // static const _enabledRing = 'enabledRing';
  static const _screenPassword = '%s_screenPassword';
  static const _enabledBiometric = '%s_enabledBiometric';
  static const _chatFontSizeFactor = '%s_chatFontSizeFactor';
  static const _chatBackground = '%s_chatBackground';

  DataSp._();

  static init() async {
    await SpUtil().init();
  }

  static String getKey(String key) {
    return sprintf(key, [OwlIM.iMManager.userID]);
  }

  static String? get imToken => getLoginCertificate()?.imToken;

  static String? get chatToken => getLoginCertificate()?.chatToken;

  static String? get userID => getLoginCertificate()?.userID;

  static bool? get isInit => getIsInit();

  static String? get devicePassword => getDevicePassword();

  static List<String> get userIDs => getAccounts() ?? [];

  static int? get lastVerifyPwdTime => getLastVerifyPwdTime(); // 上次校验密码的时间点

  static int? get verifyPwdGap => getVerifyGapPwdTime(); //间隔校验密码的时长

  static ThemeMode? get appTheme => ThemeMode.values
      .firstWhere((e) => e.name == getTheme(), orElse: () => ThemeMode.system);

  static Future<bool>? putIsInit() {
    return SpUtil().putBool(_isInit, false);
  }

  static Future<bool>? putLoginCertificate(LoginCertificate lc) {
    return SpUtil().putObject(_loginCertificate, lc);
  }

  static bool? getIsInit() {
    return SpUtil().getBool(_isInit);
  }

  static String? getDevicePassword() {
    return SpUtil().getString(
      _devicePassword,
    );
  }

  static Future<bool>? putDevicePasswrd(String password) {
    return SpUtil().putString(_devicePassword, password);
  }

  static int? getLastVerifyPwdTime() {
    return SpUtil().getInt(
      _lastVerifyPwdTime,
    );
  }

  static Future<bool>? putLastVerifyPwdTime(int time) {
    return SpUtil().putInt(_lastVerifyPwdTime, time);
  }

  static int? getVerifyGapPwdTime() {
    return SpUtil().getInt(_verifyPwdGap,
        defValue: const Duration(days: 1).inMilliseconds);
  }

  static Future<bool>? putVerifyGapPwdTime(int time) {
    return SpUtil().putInt(_verifyPwdGap, time);
  }

  static LoginCertificate? getLoginCertificate() {
    return SpUtil()
        .getObj(_loginCertificate, (v) => LoginCertificate.fromJson(v.cast()));
  }

  static Future<bool>? removeLoginCertificate() {
    return SpUtil().remove(_loginCertificate);
  }

  static List<String>? getAccounts() {
    return SpUtil().getStringList(_accounts);
  }

  static Future<bool>? addAccounts(String userID) {
    var list = List<String>.from(getAccounts() ?? []);
    if (!list.contains(userID)) {
      list.add(userID);
    }
    return SpUtil().putStringList(_accounts, list);
  }

  static Future<bool>? removeAccounts(String userID) {
    final list = getAccounts() ?? [];
    list.remove(userID);
    return SpUtil().putStringList(_accounts, list);
  }

  static Future<bool>? putServerConfig(Map<String, String> config) {
    return SpUtil().putObject(_server, config);
  }

  static Map? getServerConfig() {
    return SpUtil().getObject(_server);
  }

  static Future<bool>? putServerIP(String ip) {
    return SpUtil().putString(ip, ip);
  }

  static String? getServerIP() {
    return SpUtil().getString(_ip);
  }

  static String getDeviceID() {
    String id = SpUtil().getString(_deviceID) ?? '';
    if (id.isEmpty) {
      id = const Uuid().v4();
      SpUtil().putString(_deviceID, id);
    }
    return id;
  }

  static Future<bool>? putLanguage(int index) {
    return SpUtil().putInt(_language, index);
  }

  static int? getLanguage() {
    return SpUtil().getInt(_language);
  }

  static Future<bool>? putTheme(ThemeMode theme) {
    return SpUtil().putString(_appTheme, theme.name);
  }

  static String? getTheme() {
    return SpUtil().getString(_appTheme);
  }

  static Future<bool>? putHaveReadUnHandleGroupApplication(
      List<String> idList) {
    return SpUtil().putStringList(getKey(_groupApplication), idList);
  }

  static Future<bool>? putHaveReadUnHandleFriendApplication(
      List<String> idList) {
    return SpUtil().putStringList(getKey(_friendApplication), idList);
  }

  static List<String>? getHaveReadUnHandleGroupApplication() {
    return SpUtil().getStringList(getKey(_groupApplication), defValue: []);
  }

  static List<String>? getHaveReadUnHandleFriendApplication() {
    return SpUtil().getStringList(getKey(_friendApplication), defValue: []);
  }

  static Future<bool>? putLockScreenPassword(String password) {
    return SpUtil().putString(getKey(_screenPassword), password);
  }

  static Future<bool>? clearLockScreenPassword() {
    return SpUtil().remove(getKey(_screenPassword));
  }

  static String? getLockScreenPassword() {
    return SpUtil().getString(getKey(_screenPassword), defValue: null);
  }

  static Future<bool>? openBiometric() {
    return SpUtil().putBool(getKey(_enabledBiometric), true);
  }

  static bool? isEnabledBiometric() {
    return SpUtil().getBool(getKey(_enabledBiometric), defValue: null);
  }

  static Future<bool>? closeBiometric() {
    return SpUtil().remove(getKey(_enabledBiometric));
  }

  static Future<bool>? putChatFontSizeFactor(double factor) {
    return SpUtil().putDouble(getKey(_chatFontSizeFactor), factor);
  }

  static double getChatFontSizeFactor() {
    return SpUtil().getDouble(
      getKey(_chatFontSizeFactor),
      defValue: Config.textScaleFactor,
    )!;
  }

  static Future<bool>? putChatBackground(String path) {
    return SpUtil().putString(getKey(_chatBackground), path);
  }

  static String? getChatBackground() {
    return SpUtil().getString(getKey(_chatBackground));
  }

  static Future<bool>? clearChatBackground() {
    return SpUtil().remove(getKey(_chatBackground));
  }

  static Future<bool>? putIgnoreVersion(String version) {
    return SpUtil().putString(_ignoreUpdate, version);
  }

  static String? getIgnoreVersion() {
    return SpUtil().getString(_ignoreUpdate);
  }
}
