import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flip = FlutterLocalNotificationsPlugin();

  NotificationService() {
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var setting = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    _flip.initialize(setting, onSelectNotification: onSelectNotification);
  }

  Future createNotificationOrder(title, description, payload) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      '150',
      'sound',
      channelDescription: 'Notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      showWhen: true,
      subText: 'Need to respond',
      visibility: NotificationVisibility.public,
      enableVibration: true,
      tag: '',
      sound: RawResourceAndroidNotificationSound('whistle'),
    );
    var iOSPlatformChannelDetails = const IOSNotificationDetails();
    var platformChannelDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSPlatformChannelDetails,
    );
    var nPayLoad = json.encode(payload);
    await _flip.show(0, title, description, platformChannelDetails, payload: nPayLoad);
  }

  Future showNormalNotification(title, description, payload) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      '160',
      'normal_sound',
      channelDescription: 'Normal Notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      visibility: NotificationVisibility.public,
      enableVibration: true,
      tag: '',
      sound: RawResourceAndroidNotificationSound('normal'),
    );
    var iOSPlatformChannelDetails = const IOSNotificationDetails();
    var platformChannelDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSPlatformChannelDetails,
    );
    var nPayload = json.encode(payload);
    await _flip.show(1, title, description, platformChannelDetails, payload: nPayload);
  }

  onSelectNotification(String? data) {}
}
