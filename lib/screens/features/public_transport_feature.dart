import 'package:flutter/material.dart';

class PublicTransportFeature extends StatelessWidget {
  const PublicTransportFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bus, size: 80, color: Colors.blue),
            SizedBox(height: 24),
            Text(
              "Public Transport",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Find matatus, buses, and more for your daily commute. "
              "Get real-time schedules, routes, and fare information to save money every day.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}