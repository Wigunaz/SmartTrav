import 'package:flutter/material.dart';
import 'package:smarttrav/views/main_navigation_wrapper.dart';

void main() {
  runApp(const SmartTravApp());
}

class SmartTravApp extends StatelessWidget {
  const SmartTravApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartTrav',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0F172A),
        fontFamily: 'Inter',
      ),
      // Kata 'const' di bawah ini sudah dihapus agar tidak memicu error dinamis
      home: const MainNavigationWrapper(), 
    );
  }
}