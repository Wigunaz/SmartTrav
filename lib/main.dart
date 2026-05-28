import 'package:flutter/material.dart';
// 1. TAMBAHKAN IMPORT BARU UNTUK HALAMAN LOGIN
import 'package:smarttrav/views/auth/login_view.dart'; 

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
        scaffoldBackgroundColor: Colors.white,
      ),
      // 2. UBAH BAGIAN INI AGAR MENGARAH KE LOGINVIEW SEBAGAI HALAMAN PERTAMA
      home: const LoginView(), 
    );
  }
}