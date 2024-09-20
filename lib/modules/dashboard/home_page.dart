import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;
  final int id;
  const HomePage({super.key, required this.username, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text(username),
        ),
      ),
    );
  }
}
