import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_waste_mobile/screens/announcement_screen.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  GlobalKey<NavigatorState>? navigatorKey;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    try {
      const AndroidInitializationSettings androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iOSinitializationSettings = DarwinInitializationSettings();

      const InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitialization,
        iOS: iOSinitializationSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          _handleNotificationTap(response);
        },
      );
    } catch (e) {
      debugPrint("Notification Initialization Error: $e");
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
      debugPrint("Notification tapped with payload: ${response.payload}");
        
          if(response.payload == 'Announcement'){
                navigatorKey!.currentState?.push(
                  MaterialPageRoute(builder: (context) => const AnnouncementScreen())
                );

          }else{
                debugPrint("Error ${response.payload}");
          }

    
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required payload

    
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_test_channel',
      'High Test Channel',
      channelDescription: 'Channel for testing notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
    
    );

  
    }
  
}