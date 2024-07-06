import 'package:flutter/material.dart';
import 'package:task_app_appdid/google_auth.dart';
import 'package:task_app_appdid/home_screen.dart';

class GoogleSignInAppdid extends StatefulWidget {
  const GoogleSignInAppdid({super.key});

  @override
  State<GoogleSignInAppdid> createState() => _GoogleSignInAppdidState();
}

class _GoogleSignInAppdidState extends State<GoogleSignInAppdid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              signInWithGoogle();
              //! it can't navigate to the Home Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk08repdLZltNjAVktggJpPEQiJJTBx79mPA&s",
                    height: 35,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Sign in With Google',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sign Out
  googleSignOut() async {
    await googleSignOut();
  }
}
