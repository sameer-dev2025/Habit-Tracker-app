import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/services/database.dart';
import 'package:habit_tracker/shared/constants.dart';
import 'package:habit_tracker/shared/loading.dart';

class EditHabitForm extends StatefulWidget {
  final String habitId;
  final String currentName;

  const EditHabitForm({
    super.key,
    required this.habitId,
    required this.currentName,
  });

  @override
  State<EditHabitForm> createState() => _EditHabitFormState();
}

class _EditHabitFormState extends State<EditHabitForm> {
  final _formkey = GlobalKey<FormState>();
  String _updateHabitName = '';
  final user = FirebaseAuth.instance.currentUser!;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _updateHabitName = widget.currentName;
  }

  void _submit() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      await DatabaseService(
        uid: user.uid,
      ).updateHabitName(widget.habitId, _updateHabitName.trim());

      setState(() {
        loading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.words,
              initialValue: _updateHabitName,
              decoration: textInputDecoration.copyWith(labelText: 'Edit Habit'),
              onChanged:
                  (value) => setState(() {
                    _updateHabitName = value;
                  }),
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Plese enter a habit name'
                          : null,
            ),
            const SizedBox(height: 20),
            loading
                ? Loading()
                : ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Update Habit'),
                ),
          ],
        ),
      ),
    );
  }
}
