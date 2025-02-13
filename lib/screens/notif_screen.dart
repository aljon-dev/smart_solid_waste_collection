import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/widgets/drawer_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';

class NotifScreen extends StatefulWidget {
  const NotifScreen({super.key});

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  bool hasLoaded = false;
  double lat = 0;
  double lng = 0;

  getLocation() async {
    determinePosition();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) async {
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        hasLoaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const DrawerWidget(),
      backgroundColor: background,
      body:  Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'Smart Solid\nWaste Collector',
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                                Image.asset(
                                  'assets/images/image-removebg-preview (7) 1.png',
                                  height: 125,
                                ),
                                TextWidget(
                                  text: 'Garbage Truck Tracker',
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'Bold',
                                ),
                              ],
                            ),
                            Builder(builder: (context) {
                              return IconButton(
                                onPressed: () async {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              TextWidget(
                                text: 'Notifications',
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Bold',
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: _firestore.collection('Notifications').orderBy('TimeStamp',descending: true).snapshots(), 
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  if(snapshot.hasError){
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if(!snapshot.hasData){
                                     return const Center(child: CircularProgressIndicator(),);
                                  }

                                  final notif = snapshot.data!.docs;

                                  return Expanded(child: ListView.builder(
                                    itemCount: notif.length,
                                    itemBuilder: (context,index){
                                      
                                      final notifications = notif[index];

                                      DateTime timestamp = notifications['TimeStamp'].toDate();

                                      String formattedTime = DateFormat('MMM d, yyyy hh:mm a').format(timestamp);

                                    
                                      return Card(
                                        child:  ListTile(
                                          title: Text('Garbage ${notifications['GBPoint']}'),
                                          subtitle: Text('  ${notifications['Message']}\n  $formattedTime '),
                                      
                                      ),
                                      );


                                    }));
                                })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            )
          );
        }
         

  
  }

  bool isSameDay(Timestamp timestamp) {
    // Convert the timestamp to a DateTime
    DateTime timestampDate = timestamp.toDate();

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Compare year, month, and day
    return timestampDate.year == currentDate.year &&
        timestampDate.month == currentDate.month &&
        timestampDate.day == currentDate.day;
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

