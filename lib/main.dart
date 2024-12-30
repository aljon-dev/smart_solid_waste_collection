import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_waste_mobile/firebase_options.dart';
import 'package:smart_waste_mobile/screens/home_screen.dart';
import 'package:smart_waste_mobile/screens/landing_screen.dart';
import 'package:smart_waste_mobile/services/backgroundService.dart';

import 'services/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'garbage-collector-8c46b',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  NotificationService notificationService = NotificationService();
  await notificationService.init(); 

  await initializeService();



  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

   final _firestore = FirebaseFirestore.instance;
   final notificationService = NotificationService();
   Timestamp today = Timestamp.fromDate(DateTime.now());

   
Future<void> requestNotificationPermission() async{
    if(await Permission.notification.isDenied){
      await Permission.notification.request();
    }
  }

  
@override
initState(){
  super.initState();
    requestNotificationPermission();
   
}

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
