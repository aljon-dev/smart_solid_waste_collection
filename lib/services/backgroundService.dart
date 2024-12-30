

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:smart_waste_mobile/services/notification.dart';

final notificationService = NotificationService();
final _firestore = FirebaseFirestore.instance;


Future<void> initializeService() async{

   final service = FlutterBackgroundService();

   await service.configure(iosConfiguration: IosConfiguration(
    onBackground: onIosBackground,
    onForeground: onStart,
   ), 
   androidConfiguration: AndroidConfiguration(
   onStart: onStart, 
   isForegroundMode:true,
   notificationChannelId: 'high_sample_channel',
   initialNotificationTitle: 'Running in Background',
   initialNotificationContent: 'Monitoring notifications...',
   foregroundServiceNotificationId: 888
   
   )
   );
    service.startService();
}

bool onIosBackground(ServiceInstance service){
  return true;
}

void onStart(ServiceInstance service)async{
  if(service is AndroidServiceInstance){
    service.on('stopService').listen((event){
      service.stopSelf();
    });
  }

  notificationService.init();

  Timer.periodic(const Duration(minutes:  1),(timer) async {
    final now = DateTime.now();
    final startTime = now.subtract(const Duration(minutes:1));
    final endTime = now.add(const Duration(minutes: 1));

  final snapshot = await _firestore
        .collection('Notifications')
        .where('TimeStamp', isGreaterThan: startTime)
        .where('TimeStamp', isLessThan: endTime)
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (final data in snapshot.docs) {
        notificationService.showNotification(
          id: data.hashCode,
          title: data['GBPoint'],
          body: data['Message'],
        );
      }
    }
  });

}

 
