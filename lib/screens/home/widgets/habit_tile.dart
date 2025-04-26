import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/habit_detail.dart';
import 'package:habit_tracker/screens/home/edit_habit_form.dart';
import 'package:habit_tracker/services/database.dart';

class HabitTile extends StatelessWidget {
  final String habitId;
  final String habitName;
  final List<String> completedDays;
  final int completedDaysCount;
  final bool iscompletedToday;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  const HabitTile({
    super.key,
    required this.habitId,
    required this.habitName,
    required this.completedDaysCount,
    required this.completedDays,
    required this.iscompletedToday,
    required this.onTap,
    required this.onDelete,
  });

  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => HabitDetails(
            habitId: habitId, 
            habitName: habitName, 
            completedDays: completedDays)
          )
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListTile(
          title: Text(habitName),
          subtitle: Text('completed Days: $completedDaysCount'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(value: iscompletedToday, onChanged: (_) => onTap()),

              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder:
                        (context) => EditHabitForm(
                          habitId: habitId,
                          currentName: habitName,
                        ),
                  );
                },
              ),

              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
