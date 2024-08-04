import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:owl_common/owl_common.dart';

class PushController extends GetxController {
  String _platformVersion = 'Unknown';
  String _payloadInfo = 'Null';
  String _notificationState = "";
  String _getClientId = "";
  String _getDeviceToken = "";
  String _onReceivePayload = "";
  String _onReceiveNotificationResponse = "";
  String _onAppLinkPayLoad = "";

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    // _initializeFCM();
  }

  void _initializeFCM() async {
    // 获取设备Token
    // _getDeviceToken = await _firebaseMessaging.getToken() ?? '';

    // // 初始化本地通知插件
    // _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // const AndroidInitializationSettings initializationSettingsAndroid =
    // AndroidInitializationSettings('@mipmap/ic_launcher');
    // final InitializationSettings initializationSettings =
    // InitializationSettings(android: initializationSettingsAndroid);
    // await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 配置消息处理
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  void _onMessage(RemoteMessage message) {
    Logger.print("FCM onMessage: ${message.data}");
    _payloadInfo = message.data['payload'];
    _notificationState = 'Arrived';

    // 显示本地通知
    _showNotification(message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    Logger.print("FCM onMessageOpenedApp: ${message.data}");
    _notificationState = 'Clicked';
    _onReceiveNotificationResponse = "${message.data}";
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: "这是描述",
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    // await _flutterLocalNotificationsPlugin.show(
    //   0, // 通知ID
    //   message.notification?.title ?? 'New Notification',
    //   message.notification?.body ?? 'You have received a new message',
    //   platformChannelSpecifics,
    //   payload: 'item x',
    // );
  }
}