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
                            )),
                          );
                        }

                        final data = snapshot.requireData;

                        String status = 'On Going';
                        return Expanded(
                          child: ListView.builder(
                            itemCount: data.docs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Green Box
                                    Expanded(
                                      child: Container(
                                        height: 80,
                                        color: Colors.green[200],
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextWidget(
                                                  text:
                                                      'Location: ${data.docs[index]['location']}',
                                                  fontSize: 14,
                                                  fontFamily: 'Bold',
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextWidget(
                                                  align: TextAlign.start,
                                                  text:
                                                      '${data.docs[index]['Feedback']}',
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
                                    const Column(
                                      children: [
                                        Icon(
                                          Icons.list_alt,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'On Going',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
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
