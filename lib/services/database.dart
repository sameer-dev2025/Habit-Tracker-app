import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //constructor
  DatabaseService({required this.uid});

  //Reference to the 'habits subcollection for this user'
  CollectionReference<Map<String, dynamic>> get habitCollection {
    return _firestore.collection('users').doc(uid).collection('habits');
  }

  //get habit stream
  Stream<QuerySnapshot<Map<String, dynamic>>> get habits {
    return habitCollection.orderBy('createdAt', descending: true).snapshots();
  }

  //add habit method
  Future<void> addHabit(String name) async {
    try {
      await habitCollection.add({
        'name': name,
        'createdAt': Timestamp.now(),
        'completedDays': [],
      });
    } catch (e) {
      print('Failed to add habiit: $e');
    }
  }

  Future<void> updateHabitName(String habitId, String newName) async {
    final habitRef = habitCollection.doc(habitId);
    await habitRef.update({'name': newName,
    });
  }

  Future<void> deleteHabit(String habitId) async {
    final habitRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habitId);

    await habitRef.delete();
  }

  Future<void> toggleHabitCompleted(
    String habitID,
    String todayDate,
    bool isCompletedToday,
  ) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final habitRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitID);

    final docSnapshot = await habitRef.get();
    final data = docSnapshot.data() as Map<String, dynamic>;
    final completedDays = List<String>.from(data['completedDays'] ?? []);

    if (isCompletedToday) {
      completedDays.remove(todayDate);
    } else {
      completedDays.add(todayDate);
    }

    await habitRef.update({'completedDays': completedDays});
  }
}
