// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Map<dynamic, dynamic> localNotificationIds = {};

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(
      BuildContext context, Function handleNotificationData) {
    var androidInitialize = const AndroidInitializationSettings('appicon');
    var iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notificationResponse) async {
      if (notificationResponse.payload != null) {
        handleNotificationData(json.decode(notificationResponse.payload!));
      }
    });
  }

  static NotificationDetails get notificationDetails =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "com.iteeha.app",
          "com.iteeha.app",
          // "this is out channel",
          importance: Importance.max,
          priority: Priority.high,
          color: Color(0xFF34B53A),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  static void display(RemoteMessage message) async {
    //
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
