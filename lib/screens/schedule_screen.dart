
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_waste_mobile/screens/announcement_screen.dart';
import 'package:smart_waste_mobile/screens/notif_screen.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/utlis/distance_calculations.dart';
import 'package:smart_waste_mobile/utlis/schedule_data.dart';
import 'package:smart_waste_mobile/widgets/button_widget.dart';
import 'package:smart_waste_mobile/widgets/drawer_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {



  String nameSearched = '';

  final _firestore = FirebaseFirestore.instance;

  String selectedDay = 'All';

  final List<String> daysOrder = [
    'All', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  

  int index = 0;
  bool isNote = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const DrawerWidget(),
        backgroundColor: background,
        body: Padding(
          padding: const EdgeInsets.all(20),
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
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AnnouncementScreen()));
                    },
                    icon: const Icon(
                      Icons.campaign_outlined,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: TextWidget(
                          text: 'Smart Solid\nWaste Collector',
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        text: 'SCHEDULE',
                        fontSize: 18,
                        color: Colors.black,
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
                width: double.infinity,
                height: 600,
    
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                   
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: 'Time',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    
                     Padding(
           padding: const EdgeInsets.all(10),
             child: SizedBox(
              width: double.infinity,
              child: Container(
              decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.circular(10), // Rounded corners
              border: Border.all(color: Colors.white, width: 2), // White border
             ),
            child: DropdownButtonHideUnderline( // Hides the default underline
               child: DropdownButton<String>(
                 isExpanded: true,
                value: selectedDay,
               items: daysOrder.map((String day) {
                return DropdownMenuItem(
                value: day,
               child: Text(day, style: const TextStyle(color: Colors.black)), // Black text for visibility
              );
                }).toList(),
             onChanged: (String? newValue) {
               setState(() {
                  selectedDay = newValue!;
              });
           },
            dropdownColor: Colors.white, // White dropdown background
              ),
            ),
          ),
        ),
       ),


          StreamBuilder<QuerySnapshot>(stream:_firestore.collection('Schedules').snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots){
                      if(snapshots.hasError){
                        return const Center(child:Text('Error '));
                      }

                      if(!snapshots.hasData){
                        return const Center(child: CircularProgressIndicator(),);
                      }

                  

                     List<QueryDocumentSnapshot> sched = snapshots.data!.docs;

                     sched.sort((a,b){
                      String dayA = a['day'] ?? '';
                      String dayB = b['day'] ?? '';

                      int indexA = daysOrder.indexOf(dayA);
                      int indexB = daysOrder.indexOf(dayB);

                      return indexA.compareTo(indexB);

                     });

                     if(selectedDay != 'All'){
                      sched = sched.where((doc)=> doc['day'] == selectedDay).toList();
                     }

                    return Expanded(child: ListView.builder(
                      itemCount: sched.length,
                      itemBuilder: (context,index){

                        final schedules  = sched[index];


                        return  Card(
                          child: Padding(padding: EdgeInsets.all(16),
                          child: Container(
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                Text('Barangay: ${schedules['barangay'] ?? ' No Barangay'} ',style: const TextStyle(
                                  color:Colors.black,
                                  fontSize: 20,
                                ),
                                ),
                              const  SizedBox(height: 1,),
                                 Text('Note:${schedules['note'] ?? ' No Notes'} ',style: const TextStyle(
                                  color:Colors.black,
                                  fontSize: 15,
                                ),),

                               const  SizedBox(height: 1,),
                                 Text('Day:${schedules['day'] ?? ' No Day'} ',style: const TextStyle(
                                  color:Colors.black,
                                  fontSize: 15,
                                ),),

                                 const SizedBox(height: 1,),
                                 Text('Note:${schedules['note'] ?? ' No Notes'} ',style: const TextStyle(
                                  color:Colors.black,
                                  fontSize: 15,
                                ),),


                                const SizedBox(height: 1,),
                                 Text('Time:${schedules['timeF'] } - ${schedules['timeT'] } ',style: const TextStyle(
                                  color:Colors.black,
                                  fontSize: 15,
                                ),)
                          
                             ],
                            ),
                          ),
                          )
                        );





                    }
                    ));
                          

                    }
                  )
                  
                    
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
