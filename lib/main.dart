import 'package:flutter/material.dart';
import 'package:task_app_appdid/categories.dart';
import 'package:task_app_appdid/home_screen.dart';
import 'package:task_app_appdid/meal_details.dart';

import 'google_sign_in.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleSignInAppdid(),
    ),
  );
}
