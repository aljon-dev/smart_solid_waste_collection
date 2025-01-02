import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    try {
      // Android Initialization for Notifications
      const AndroidInitializationSettings androidInitialization =
          AndroidInitializationSettings('@mipmap/ic_launcher'); // Default Icon

      // IPhone Initialization
      const DarwinInitializationSettings iOSinitializationSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Setting up Initialize for Notifications  both Platforms
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: androidInitialization,
        iOS: iOSinitializationSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          print('Notification tapped on: ${response.payload}');
        },
      );

      // Notification for Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_sample_channel',
        'High Test Channel',
        description: 'A SAMPLE TEST CHANNEL ',
        importance: Importance.max,
        playSound: true,
        enableLights: true,
        enableVibration: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      print(e);
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails('high_test_channel', 'High Test Channel',
              channelDescription: ' JUST TESTING ',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              enableVibration: true,
              enableLights: true,
              icon: '@mipmap/ic_launcher');

      // for IOS
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true);

      //Platform Details

      const NotificationDetails platfromDetails =
          NotificationDetails(android: androidDetails, iOS: iosDetails);

      await flutterLocalNotificationsPlugin
          .show(id, title, body, platfromDetails, payload: payload);

      // lets see if working  for debugging
      print("Notification sent test: ID=$id");
    } catch (e) {
      print(" Error Notif $e");
    }
  }
}
