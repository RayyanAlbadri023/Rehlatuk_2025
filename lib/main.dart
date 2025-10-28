// Example in lib/main.dart
import 'package:flutter/material.dart';
import 'admin_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
// Import your new file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin App',
      // Set the AdminHomePage as the initial screen
      home: AdminHomePage(),
    );
  }
}