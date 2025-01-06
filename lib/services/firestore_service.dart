import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_helper/models/faculty.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Faculty>> getFaculties() {
    return _firestore.collection('faculties').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Faculty.fromFirestore(doc)).toList();
    });
  }
}
