import 'package:flutter/material.dart';

class LogisticsScreen extends StatefulWidget {
  const LogisticsScreen({super.key});

  @override
  State<LogisticsScreen> createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _truckAnimation;

  final List<Map<String, dynamic>> _timelineData = [
    {
      'status': 'Collected',
      'time': '2:30 PM',
      'icon': Icons.check_circle,
      'color': const Color(0xFF00C853),
      'completed': true
    },
    {
      'status': 'In transit',
      'time': 'Expected 3:15 PM',
      'icon': Icons.circle,
      'color': const Color(0xFFFFD600),
      'completed': false,
      'subtitle': '+15 min delay'
    },
    {
      'status': 'Delivered',
      'time': 'Estimated 4:00 PM',
      'icon': Icons.crop_square,
      'color': Colors.grey,
      'completed': false
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _truckAnimation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment Tracker'),
      ),
      body: Column(
        children: [
          // Map Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _truckAnimation,
                      builder: (context, child) {
                        return Align(
                          alignment: _truckAnimation.value,
                          child: const Icon(
                            Icons.local_shipping,
                            color: Color(0xFF2962FF),
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Timeline Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                itemCount: _timelineData.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final item = _timelineData[index];
                  return _buildTimelineItem(
                    icon: item['icon'] as IconData,
                    color: item['color'] as Color,
                    time: item['time'] as String,
                    status: item['status'] as String,
                    subtitle: item['subtitle'] as String?,
                    completed: item['completed'] as bool,
                  );
                },
              ),
            ),
          ),
          
          // Call Driver Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Call Driver',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color color,
    required String time,
    required String status,
    String? subtitle,
    required bool completed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: color,
          size: 30,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  color: completed ? color : Colors.grey,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: completed ? color : Colors.black,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
