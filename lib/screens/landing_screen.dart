import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smart_waste_mobile/services/data.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/widgets/button_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';
import 'package:smart_waste_mobile/widgets/toast_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final box = GetStorage();

  Future<void> requestNotificationPermission() async{
    if(await Permission.notification.isDenied){
      await Permission.notification.request();
    }
  }

  
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
       requestNotificationPermission();
    determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: background),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Smart Solid Waste Collector',
                    fontSize: 32,
                    fontFamily: 'Bold',
                    color: Colors.white,
                  ),
                  Image.asset('assets/images/image-removebg-preview (7) 1.png'),
                  TextWidget(
                    text: '''
        Navigate the Future, Track your Solid Waste Truck Collector: Our Smart Truck for Waste Collectors Leads the Way to a Cleaner Tomorrow!
        ''',
                    fontSize: 12,
                    fontFamily: 'Bold',
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              ButtonWidget(
                color: primary,
                width: 250,
                radius: 15,
                fontSize: 18,
                label: 'Get Started',
                onPressed: () async {
                  // for (int i = 0; i < latLongData.length; i++) {
                  //   await FirebaseFirestore.instance
                  //       .collection('Collection Points')
                  //       .doc()
                  //       .set(latLongData[i]);
                  // }
                  box.write('started', true);
                  box.write('toshow', true);

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
