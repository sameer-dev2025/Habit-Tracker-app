import 'package:flutter/material.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/screens/authenticate/authenticate.dart';
import 'package:habit_tracker/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Userdata?>(context);
    if (user == null) {
    // Show login or sign-in screen
    return Authenticate();
  } else {
    // Show authenticated content
    return Home();
    }
  }
}
