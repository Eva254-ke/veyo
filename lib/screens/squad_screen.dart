import 'package:flutter/material.dart';

class SquadScreen extends StatefulWidget {
  const SquadScreen({super.key});

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final double _progressValue = 2/3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save 50% with squads'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildAvatarStack(),
            const SizedBox(height: 30),
            _buildProgressRing(),
            const SizedBox(height: 30),
            _buildFareCard(),
            const Spacer(),
            _buildPulseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://example.com/user-avatar.jpg'),
        ),
        _buildAddAvatar(),
        _buildAddAvatar(),
      ],
    );
  }

  Widget _buildAddAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[200],
      child: IconButton(
        icon: const Icon(Icons.add, size: 30),
        color: Colors.grey[600],
        onPressed: () {},
      ),
    );
  }

  Widget _buildProgressRing() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: _progressValue,
            strokeWidth: 8,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C853)),
          ),
        ),
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('2/3', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('seats filled', style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildFareCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('You pay:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('50 KES', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('100 KES normally',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[600],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (_animationController.value * 0.1),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD600),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: const Text('Confirm Squad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
