import 'package:flutter/material.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_tracker/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Userdata?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: Wrapper()),
    );
  }
}
