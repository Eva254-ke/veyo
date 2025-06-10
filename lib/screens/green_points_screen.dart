import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GreenPointsScreen extends StatefulWidget {
  const GreenPointsScreen({super.key});

  @override
  State<GreenPointsScreen> createState() => _GreenPointsScreenState();
}

class _GreenPointsScreenState extends State<GreenPointsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  int _userPoints = 0;
  bool _loading = true;
  bool _showPoints = false;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _progressController.forward();
  }

  Future<void> _fetchUserPoints() async {
    if (_user == null) return;
    final doc = await FirebaseFirestore.instance.collection('green_points').doc(_user.uid).get();
    setState(() {
      _userPoints = doc.exists && doc.data() != null && doc.data()!['points'] != null ? doc.data()!['points'] as int : 0;
      _loading = false;
    });
  }

  Future<void> _earnPoints(int points, String reason) async {
    if (_user == null) return;
    final ref = FirebaseFirestore.instance.collection('green_points').doc(_user.uid);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      int newPoints = points;
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!['points'] != null) {
        newPoints += snapshot.data()!['points'] as int;
      }
      transaction.set(ref, {'points': newPoints, 'lastEarned': DateTime.now(), 'lastReason': reason}, SetOptions(merge: true));
    });
    _fetchUserPoints();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You earned $points points for $reason!')));
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.eco, color: Color(0xFF00C853)),
            SizedBox(width: 8),
            Text(
              'Your Green Impact',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: !_showPoints
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.eco),
                label: const Text('Show My Green Points'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  setState(() => _loading = true);
                  await _fetchUserPoints();
                  setState(() {
                    _showPoints = true;
                  });
                },
              ),
            )
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Your Green Points: $_userPoints', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProgressRingCard(
                            label: '5kg Plastic',
                            points: 500,
                            icon: Icons.recycling,
                            animation: _progressAnimation,
                          ),
                          _buildSimpleStatCard(
                            label: '10km Walked',
                            points: 100,
                            icon: Icons.directions_walk,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.electric_car),
                        label: const Text('Take Electric Car (Earn 200 pts)'),
                        onPressed: () => _earnPoints(200, 'Taking Electric Car'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Redeem your points for rewards:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildRedemptionCard(
                            title: 'Free Ride',
                            points: 500,
                            icon: Icons.directions_bus,
                            color: Colors.blueAccent,
                          ),
                          _buildRedemptionCard(
                            title: 'Solar Lamp',
                            points: 1000,
                            icon: Icons.wb_sunny,
                            color: Colors.orangeAccent,
                          ),
                          _buildRedemptionCard(
                            title: 'Eco Bottle',
                            points: 300,
                            icon: Icons.local_drink,
                            color: Colors.green,
                          ),
                          _buildRedemptionCard(
                            title: 'Tree Planting',
                            points: 200,
                            icon: Icons.park,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProgressRingCard({
    required String label,
    required int points,
    required IconData icon,
    required Animation<double> animation,
  }) {
    return SizedBox(
      width: 140,
      height: 160,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: animation.value,
                      strokeWidth: 8,
                      color: const Color(0xFF00C853),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Icon(icon, size: 30, color: const Color(0xFF00C853)),
              const SizedBox(height: 8),
              Text(
                '$label → $points pts',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleStatCard({
    required String label,
    required int points,
    required IconData icon,
  }) {
    return SizedBox(
      width: 140,
      height: 160,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.orange.shade700),
              const SizedBox(height: 16),
              Text(
                '$label → $points pts',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRedemptionCard({
    required String title,
    required int points,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Redemption action here
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$points pts',
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
