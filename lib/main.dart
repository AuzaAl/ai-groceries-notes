import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GroceryNotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F3F0),
        fontFamily: 'PlusJakartaSans',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4E6953),
          onPrimary: Colors.white,
          secondary: Color(0xFF4A654F),
          surface: Colors.white,
          onSurface: Color(0xFF061B0E),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}