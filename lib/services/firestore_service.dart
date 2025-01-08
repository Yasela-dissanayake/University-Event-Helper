import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllFaculties() {
    return _firestore.collection('faculties').snapshots();
  }

  Stream<QuerySnapshot> getFacultyEvents(String facultyId) {
    return _firestore
        .collection('faculties')
        .doc(facultyId)
        .collection('events')
        .limit(1) // Get only one event
        .snapshots();
  }
}
