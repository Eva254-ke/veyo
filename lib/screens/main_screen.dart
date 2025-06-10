import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'squad_screen.dart';
import 'logistics_screen.dart';
import 'green_points_screen.dart';
// ignore: unused_import
import 'smart_routes_screen.dart';
import 'account_screen.dart'; // Import AccountScreen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens for each tab (replace with your real widgets)
  final List<Widget> _screens = [
    const HomeScreen(),
    const SquadScreen(),
    const LogisticsScreen(),
    const GreenPointsScreen(),
    const AccountScreen(), // Replaced SmartRoutesScreen with AccountScreen
  ];

  final List<String> _titles = [
    'Home',
    'Squad',
    'Logistics',
    'Green Points',
    'Account', // Changed from 'Wallet'
  ];

  // Vibrant colors for each tab
  final List<Color> _tabColors = [
    const Color(0xFF00C853), // Green
    const Color(0xFF2979FF), // Blue
    const Color(0xFFFFA000), // Orange
    const Color(0xFF43A047), // Deep Green
    const Color(0xFFD500F9), // Purple
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: Text(_titles[_currentIndex]),
        backgroundColor: _tabColors[_currentIndex],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting, // Use shifting for per-tab color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: _tabColors[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: 'Squad',
            backgroundColor: _tabColors[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping),
            label: 'Logistics',
            backgroundColor: _tabColors[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.eco),
            label: 'Green Points',
            backgroundColor: _tabColors[3],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person), // Changed icon to Account
            label: 'Account', // Changed label
            backgroundColor: _tabColors[4],
          ),
        ],
      ),
    );
  }
}