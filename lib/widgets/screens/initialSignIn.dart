import 'package:flutter/material.dart';

class InitialSignIn extends StatelessWidget {
  const InitialSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/auth');
          },
          child: const Text('Sign in with Riot Games'),
        ),
      ),
    );
  }
}
