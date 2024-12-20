import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';

import '../widgets/drawer_widget.dart';

class FeedbackStatusScreen extends StatelessWidget {
  const FeedbackStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      endDrawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                TextWidget(
                  text: 'Smart Solid\nWaste Collector',
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Bold',
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
              height: 20,
            ),
            Center(
              child: Image.asset(
                'assets/images/new-removebg-preview.png',
                height: 100,
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 500,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.green[600],
                    child: Center(
                      child: TextWidget(
                        text: 'Feedback Status',
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Bold',
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Feedbacks')
                          .orderBy('postedAt', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }

                        final data = snapshot.requireData;

                        return SizedBox(
                          height: 450,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (int i = 0; i < data.docs.length; i++)
                                  Builder(
                                    builder: (context) {
                                      Map<String, dynamic> data1 = data.docs[i]
                                          .data() as Map<String, dynamic>;

                                      // Check for the 'status' field
                                      String status =
                                          data1.containsKey('status')
                                              ? data1['status']
                                              : 'Pending';

                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Green Box
                                            Expanded(
                                              child: Container(
                                                height: 80,
                                                color: Colors.green[200],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextWidget(
                                                          text:
                                                              'Location: ${data1['location']}',
                                                          fontSize: 14,
                                                          fontFamily: 'Bold',
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextWidget(
                                                          align:
                                                              TextAlign.start,
                                                          text:
                                                              '${data1['Feedback']}',
                                                          fontSize: 12,
                                                          fontFamily: 'Medium',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Status Icon with Label
                                            Column(
                                              children: [
                                                Icon(
                                                  status == 'Accomplished'
                                                      ? Icons
                                                          .check_circle_outline
                                                      : status == 'Pending'
                                                          ? Icons.list_alt
                                                          : Icons
                                                              .playlist_add_check_sharp,
                                                  color:
                                                      status == 'Accomplished'
                                                          ? Colors.green
                                                          : status == 'Pending'
                                                              ? Colors.amber
                                                              : Colors.blue,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  status,
                                                  style: TextStyle(
                                                    fontSize:
                                                        status == 'Accomplished'
                                                            ? 8
                                                            : 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
