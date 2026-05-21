import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/grocery_notes_screen.dart';

void main() {
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Inter', // Default to a clean sans-serif if you have one, or standard system fonts
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Color(0xFF1C1C1E),
        ),
      ),
      home: const GroceryNotesScreen(),
    );
  }
}