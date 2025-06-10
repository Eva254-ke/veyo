import 'package:flutter/material.dart';

class TreePlantingFeature extends StatelessWidget {
  const TreePlantingFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.park, size: 80, color: Colors.brown),
            SizedBox(height: 24),
            Text(
              "Tree Planting",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Join tree planting events and earn more green points. "
              "Help us make Nairobi a cleaner, greener city for everyone.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}