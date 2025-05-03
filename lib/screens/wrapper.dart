import 'package:flutter/material.dart';
import 'package:habit_tracker/models/user.dart';
import 'package:habit_tracker/screens/authenticate/authenticate.dart';
import 'package:habit_tracker/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Userdata?>(context);
    if (user == null) {
    return Authenticate();
  } else {
    return Home();
    }
  }
}
