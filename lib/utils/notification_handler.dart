import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> initialize() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> handleNotification(Map<String, dynamic> message) async {
    // Extract relevant data from the message
    String orderId = message['orderId'];
    String status = message['status'];

    // Display the notification
    await _displayNotification(orderId, status);
  }

  static Future<void> _displayNotification(
      String orderId, String status) async {
    const String channelId = 'package_notification_channel';
    const String channelName = 'Order Status Updates';

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      _generateNotificationId(), // Notification ID
      'Order Status Update', // Notification title
      'Your order $orderId is now $status', // Notification body
      platformChannelSpecifics,
    );
  }

  static int _notificationId = 0;

  static int _generateNotificationId() {
    // Increment the notification ID for each new notification
    return ++_notificationId;
  }
}
