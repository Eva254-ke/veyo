import 'package:flutter/material.dart';

class CarpoolFeature extends StatelessWidget {
  const CarpoolFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, size: 80, color: Colors.green),
            SizedBox(height: 24),
            Text(
              "Carpool & Squad Ride",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Share rides with friends or join a squad to split costs and reduce traffic. "
              "Find or create carpool groups easily.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}