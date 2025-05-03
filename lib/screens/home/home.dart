import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/home/add_habit_form.dart';
import 'package:habit_tracker/services/auth.dart';
import 'package:habit_tracker/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/screens/home/widgets/habit_tile.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('My Habits'),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.person, color: Colors.white),
            label: const Text('logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService(uid: user.uid).habits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No habits yet.'));
          }

          final habits = snapshot.data!.docs;

          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habitData = habits[index].data() as Map<String, dynamic>;
              final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
              final completedDays = List<String>.from(
                habitData['completedDays'] ?? [],
              );
              final isCompletedToday = completedDays.contains(today);

              return HabitTile(
                habitId: habits[index].id,
                habitName: habitData['name'],
                completedDays: completedDays,
                completedDaysCount: completedDays.length,
                iscompletedToday: isCompletedToday,

                onTap: () {
                  DatabaseService(uid: user.uid).toggleHabitCompleted(
                    habits[index].id,
                    today,
                    isCompletedToday,
                  );
                },

                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Delete Habit'),
                          content: const Text(
                            'Are you sure you want to delete this habit?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true) {
                    await DatabaseService(uid: user.uid).deleteHabit(habits[index].id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 10),
        child: FloatingActionButton(
          onPressed: () => _showAddHabitSheet(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddHabitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(child: AddHabitForm()),
        );
      },
    );
  }
}
