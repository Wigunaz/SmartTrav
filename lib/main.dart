import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/auth_controller.dart';

import 'views/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Koneksi awal ke server database Supabase lu
  await Supabase.initialize(
    url: 'https://zfkzeaohdhuzbfryjhkl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpma3plYW9oZGh1emJmcnlqaGtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAzMDA1MTcsImV4cCI6MjA5NTg3NjUxN30.9guNUlK1eliyb0c8jZfI8NI2TNb11mi8iCQoqlmENwQ',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), // Start awal aplikasi langsung hadapkan ke form login
    );
  }
}