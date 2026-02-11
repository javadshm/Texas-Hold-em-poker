import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PokerApp());
}

class PokerApp extends StatelessWidget {
  const PokerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texas Hold\'em Poker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A5F38), // Dark green
          brightness: Brightness.light,
          primary: const Color(0xFF0A5F38), // Dark poker table green
          secondary: const Color(0xFFD4AF37), // Gold
          surface: const Color(0xFFF5F5DC), // Cream/beige
          background: const Color(0xFFE8E8E0),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A5F38), // Dark green background
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xFFF5F5DC),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37), // Gold
            foregroundColor: Colors.black,
            elevation: 6,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF084130), // Darker green
          foregroundColor: Color(0xFFD4AF37), // Gold text
          elevation: 4,
          centerTitle: true,
        ),
        tabBarTheme: const TabBarTheme(
          indicatorColor: Color(0xFFD4AF37), // Gold indicator
          labelColor: Color(0xFFD4AF37), // Gold selected text
          unselectedLabelColor: Colors.white70,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
