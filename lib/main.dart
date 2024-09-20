import 'package:employee_crud/modules/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employees',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5F2F93)),
        useMaterial3: false,
      ),
      home: const LoginPage(),
    );
  }
}
