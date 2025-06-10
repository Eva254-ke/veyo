import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart'; // ✅ Import the MainScreen for bottom navigation
import 'screens/emergency_screen.dart';

class NairobiGoApp extends StatelessWidget {
  const NairobiGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nairobi Go',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C853)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/emergency': (context) => const EmergencyScreen(), // Emergency screen route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
