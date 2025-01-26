import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_waste_mobile/firebase_options.dart';
import 'package:smart_waste_mobile/screens/home_screen.dart';
import 'package:smart_waste_mobile/screens/landing_screen.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';

import 'services/notification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'garbage-collector-8c46b',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize NotificationService and pass navigatorKey
  NotificationService notificationService = NotificationService();
  notificationService.navigatorKey = navigatorKey;  // Pass global key
  await notificationService.init();

  // Start Foreground Service
  startForegroundService();

  // Initialize GetStorage
  await GetStorage.init();

  // Run the app
  runApp(const MyApp());
}

// Foreground service setup
void startForegroundService() async {
  ForegroundService().start();
  debugPrint("Started foreground service");
}

// Firestore Instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final NotificationService notificationService = NotificationService();
Timestamp today = Timestamp.fromDate(DateTime.now());

// Fetch notifications
Future<void> showNotifs() async {
  try {
    final now = DateTime.now();
    final startTime = now.subtract(const Duration(minutes: 1));
    final endTime = now.add(const Duration(minutes: 1));

    _firestore.collection('Notifications')
      .where('TimeStamp', isGreaterThan: startTime)
      .where('TimeStamp', isLessThan: endTime)
      .snapshots()
      .listen((snapshot) {
        for (final data in snapshot.docs) {
          notificationService.showNotification(
            id: 1,
            title: data['GBPoint'],
            body: data['checkpoint'],
          );
        }
      }, onError: (e) {
        debugPrint('Error fetching notifications: $e');
      });
  } catch (e) {
    debugPrint('Exception: $e');
  }
}

// Fetch announcements
Future<void> showNotifsAnnouncement() async {
  try {
    final now = DateTime.now();
    final startTime = now.subtract(const Duration(minutes: 1));
    final endTime = now.add(const Duration(minutes: 1));

    _firestore.collection('Announcements')
      .where('postedAt', isGreaterThan: startTime)
      .where('postedAt', isLessThan: endTime)
      .snapshots()
      .listen((snapshot) {
        for (final data in snapshot.docs) {
          notificationService.showNotification(
            id: 2,
            title: 'Announcement',
            body: data['announcement'],
          );
        }
      }, onError: (e) {
        debugPrint('Error fetching announcements: $e');
      });
  } catch (e) {
    debugPrint('Exception: $e');
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    
    return MaterialApp(
      navigatorKey: navigatorKey,  // Use the same navigatorKey
      home: box.read('started') ?? false
          ? const HomeScreen()
          : const LandingScreen(),
    );
  }
}
