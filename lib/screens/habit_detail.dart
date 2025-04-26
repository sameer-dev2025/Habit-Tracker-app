import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HabitDetails extends StatelessWidget {
  final String habitId;
  final String habitName;
  final List<String> completedDays;

  const HabitDetails({
    super.key,
    required this.habitId,
    required this.habitName,
    required this.completedDays,
  });

  int getCurrentStreak() {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final completedDates =
        completedDays.map((dateStr) => dateFormatter.parse(dateStr)).toList();
    completedDates.sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime today = DateTime.now();
    for (DateTime date in completedDates) {
      if (date.difference(today.subtract(Duration(days: streak))).inDays == 0) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    int streak = getCurrentStreak();
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(habitName),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Habit: $habitName', style: const TextStyle(fontSize: 20.0)),
            // const SizedBox(height: 16.0),
            Text(
              'Completed Days: ${completedDays.length}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),

            Text(
              'Current Streak: $streak',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 24.0),

            const Text('Completion Dates:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: completedDays.length,
                itemBuilder: (context, index) {
                  final date = DateFormat('dd-MM-yyy').format(
                    DateFormat('dd-MM-yyyy').parse(completedDays[index]),
                  );

                  return ListTile(
                    leading: const Icon(Icons.check),
                    title: Text(date),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
