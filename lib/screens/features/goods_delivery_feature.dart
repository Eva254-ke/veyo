import 'package:flutter/material.dart';

class GoodsDeliveryFeature extends StatelessWidget {
  const GoodsDeliveryFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 80, color: Colors.orange),
            SizedBox(height: 24),
            Text(
              "Goods & Parcel Delivery",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Send and track your goods and parcels in real-time. "
              "Fast, reliable, and affordable delivery across Nairobi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}