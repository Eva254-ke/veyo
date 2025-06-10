import 'package:flutter/material.dart';

class WomenOnlyFeature extends StatelessWidget {
  const WomenOnlyFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.female, size: 80, color: Colors.purple),
            SizedBox(height: 24),
            Text(
              "Women-Only Rides",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Safe rides for women, by women. "
              "Join or request women-only rides for comfort and peace of mind.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}