import 'package:flutter/material.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'منصة المزارعين',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RegisterScreen(),
    );
  }
}
