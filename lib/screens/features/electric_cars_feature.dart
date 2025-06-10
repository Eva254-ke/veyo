import 'package:flutter/material.dart';

class ElectricCarsFeature extends StatelessWidget {
  const ElectricCarsFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.electric_car, size: 80, color: Colors.teal),
            SizedBox(height: 24),
            Text(
              "Electric Cars",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Book or share electric vehicles for a greener Nairobi. "
              "Reduce your carbon footprint and enjoy a quiet, smooth ride.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}