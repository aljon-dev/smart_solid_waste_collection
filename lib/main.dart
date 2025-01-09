import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_waste_mobile/firebase_options.dart';
import 'package:smart_waste_mobile/screens/home_screen.dart';
import 'package:smart_waste_mobile/screens/landing_screen.dart';

import 'services/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'garbage-collector-8c46b',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService notificationService = NotificationService();
  await notificationService.init();
  showNotifs();

  // startForegroundService();
  await GetStorage.init();
  runApp(const MyApp());
}

// void startForegroundService() async {
//   ForegroundService().start();
//   debugPrint("Started service");
// }

final _firestore = FirebaseFirestore.instance;
final notificationService = NotificationService();
Timestamp today = Timestamp.fromDate(DateTime.now());

Future<void> showNotifs() async {
  try {
    final now = DateTime.now();
    final startTime = now.subtract(const Duration(minutes: 1));
    final endTime = now.add(const Duration(minutes: 1));

    _firestore
        .collection('Notifications')
        .where('TimeStamp', isGreaterThan: startTime)
        .where('TimeStamp', isLessThan: endTime)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (final data in snapshot.docs) {
          notificationService.showNotification(
              id: 1, title: data['GBPoint'], body: data['Message']);
        }
      } else {
        print('No notifications within the time range');
      }
    }, onError: (e) {
      print('$e');
    });
  } catch (e) {
    print('$e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // startForegroundService();
  }
// 
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: box.read('started') ?? false
          ? const HomeScreen()
          : const LandingScreen(),
    );
  }
}
