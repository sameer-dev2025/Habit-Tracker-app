import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/services/database.dart';
import 'package:habit_tracker/shared/constants.dart';
import 'package:habit_tracker/shared/loading.dart';

class AddHabitForm extends StatefulWidget {
  const AddHabitForm({super.key});

  @override
  State<AddHabitForm> createState() => _AddHabitFormState();
}

class _AddHabitFormState extends State<AddHabitForm> {
  final _formkey = GlobalKey<FormState>();
  String _habitName = '';
  bool loading = false;

  void _submit() async {
    final user = FirebaseAuth.instance.currentUser!;

    if (_formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      await DatabaseService(uid: user.uid).addHabit(_habitName);
      setState(() {
        loading = false;
      });

      //Close bottom sheet
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: textInputDecoration.copyWith(
              labelText: 'Habit Name', 
              hintText: 'Workout',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5),
            )),
            validator:
                (val) =>
                    val == null || val.isEmpty ? 'Enter a habit name' : null,
            onChanged: (val) {
              setState(() {
                _habitName = val;
              });
            },
          ),
          const SizedBox(height: 16.0),
          loading
              ? Loading()
              : ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Habit'),
              ),
        ],
      ),
    );
  }
}
