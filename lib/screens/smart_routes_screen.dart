import 'package:flutter/material.dart';

class SmartRoutesScreen extends StatelessWidget {
  const SmartRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Route Recommendations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopRecommendation(),
            const SizedBox(height: 30),
            _buildRouteBreakdown(),
            const SizedBox(height: 30),
            const Text('Alternatives:', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildAlternativeOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRecommendation() {
    return Card(
      elevation: 4,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.emoji_events, color: Color(0xFF00C853), size: 40),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Best: 38 mins',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('saves 21 mins',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[700],
                        fontStyle: FontStyle.italic)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteBreakdown() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTransportStep(Icons.directions_walk, 'Walk', '5 min'),
          const Icon(Icons.arrow_forward, color: Colors.grey),
          _buildTransportStep(Icons.directions_bus, 'Matatu #111', '25 min'),
          const Icon(Icons.arrow_forward, color: Colors.grey),
          _buildTransportStep(Icons.directions_bike, 'Boda', '8 min'),
        ],
      ),
    );
  }

  Widget _buildTransportStep(IconData icon, String label, String time) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue[700]),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(time, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildAlternativeOptions() {
    return Expanded(
      child: ListView(
        children: [
          _buildAlternativeOption(
            icon: Icons.currency_exchange,
            title: 'Cheapest',
            subtitle: '90 KES',
            color: Colors.orange[700]!,
          ),
          const SizedBox(height: 15),
          _buildAlternativeOption(
            icon: Icons.eco,
            title: 'Greenest',
            subtitle: 'Low CO₂',
            color: Colors.green[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, size: 32, color: color),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      subtitle: Text(subtitle),
      trailing: TextButton(
        style: TextButton.styleFrom(
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(0.1),
        ),
        onPressed: () {},
        child: Text('View Route', style: TextStyle(color: color)),
      ),
    );
  }
}
