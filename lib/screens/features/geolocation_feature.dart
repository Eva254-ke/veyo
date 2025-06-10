import 'package:flutter/material.dart';

class GeolocationFeature extends StatelessWidget {
  const GeolocationFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 80, color: Colors.red),
            SizedBox(height: 24),
            Text(
              "Geolocation Services",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Get accurate pickup and drop-off using live maps. "
              "Never get lost again with advanced geolocation technology.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}