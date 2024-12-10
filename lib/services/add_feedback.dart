import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addFeedback(email, feedback, name, List images, location) async {
  final docUser = FirebaseFirestore.instance.collection('Feedbacks').doc();

  final json = {
    'Email': email,
    'Feedback': feedback,
    'Name': name,
    'Images': images,
    'postedAt': DateTime.now(),
    'location': location,
    'status': 'Pending',
  };

  await docUser.set(json);

  return docUser.id;
}
