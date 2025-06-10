import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Feature imports (all used in categories)
import 'features/public_transport_feature.dart';
import 'features/carpool_feature.dart';
import 'features/goods_delivery_feature.dart';
import 'features/geolocation_feature.dart';
import 'features/electric_cars_feature.dart';
import 'features/women_only_feature.dart';
import 'features/green_points_feature.dart';
import 'features/tree_planting_feature.dart';
import 'select_destination_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? _firebaseUser = FirebaseAuth.instance.currentUser;
  bool _showFeatureContent = false;
  Widget? _featureContent;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, String> _categoryImages = {
    'Public Transport': 'assets/images/public_transport.jpg',
    'Carpool & Squad Ride': 'assets/images/carpool.jpg',
    'Goods & Parcel Delivery': 'assets/images/delivery.jpg',
    'Geolocation Services': 'assets/images/geolocation.jpg',
    'Electric Cars': 'assets/images/electric_car.jpg',
    'Women-Only Rides': 'assets/images/women_only.jpg',
    'Green Points': 'assets/images/green_points.jpg',
    'Tree Planting': 'assets/images/tree_planting.jpg',
  };

  void _openFeatureContent(String title, Widget content) {
    setState(() {
      _showFeatureContent = true;
      _featureContent = Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _showFeatureContent = false),
          ),
        ),
        body: content,
      );
    });
  }

  Widget _buildGreetingAndProfile() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    final user = _firebaseUser;
    String displayName;
    if (user?.displayName != null && user!.displayName!.trim().isNotEmpty) {
      // Use only the first word from displayName
      displayName = user.displayName!.trim().split(RegExp(r'\s+'))[0];
    } else if (user?.email != null && user!.email!.contains('@')) {
      // Extract the first name-like part from the email (before @, split by . _ or digits)
      final namePart = user.email!.split('@')[0];
      // Split by non-letter characters (dot, underscore, digits, etc.)
      final nameCandidates = namePart.split(RegExp(r'[^a-zA-Z]+')).where((s) => s.isNotEmpty).toList();
      if (nameCandidates.isNotEmpty) {
        // Use only the first candidate as the greeting name
        final firstName = nameCandidates[0];
        displayName = firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
      } else {
        displayName = 'User';
      }
    } else {
      displayName = 'User';
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting,',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF222B45)),
                ),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green[100],
            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null ? const Icon(Icons.person, size: 32, color: Colors.green) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Where to?',
            prefixIcon: const Icon(Icons.search, color: Colors.green),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SelectDestinationScreen(initialQuery: query.trim()),
                ),
              );
            }
          },
          readOnly: false,
          onTap: () {
            // Optionally, you can open the map on tap as well
            // Navigator.of(context).push(...)
          },
        ),
      ),
    );
  }

  void _showMpesaValueDialog() {
    final TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/icons/mpesa.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.mobile_friendly, color: Colors.white, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Get 3 Discounted Rides!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pay KES 200 via Mpesa and instantly unlock 3 discounted rides. Enjoy more value and convenience with Nairobi Go!',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text('Enter your Mpesa phone number:'),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'e.g. 07XXXXXXXX',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final phone = phoneController.text.trim();
              if (phone.isEmpty || phone.length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid phone number.')),
                );
                return;
              }
              Navigator.of(context).pop();
              _startMpesaPayment(phone);
            },
            child: const Text('Pay KES 200'),
          ),
        ],
      ),
    );
  }

  void _startMpesaPayment(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mpesa STK Push for KES 200 sent to $phone. Enter your Mpesa PIN to complete.')),
    );
  }

  Widget _buildCategories() {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Public Transport',
        'description': 'Find matatus, buses, and more for your daily commute.',
        'image': _categoryImages['Public Transport'],
        'widget': const PublicTransportFeature(),
      },
      {
        'title': 'Carpool & Squad Ride',
        'description': 'Share rides with friends or colleagues and save.',
        'image': _categoryImages['Carpool & Squad Ride'],
        'widget': const CarpoolFeature(),
      },
      {
        'title': 'Goods & Parcel Delivery',
        'description': 'Send and receive parcels quickly and safely.',
        'image': _categoryImages['Goods & Parcel Delivery'],
        'widget': const GoodsDeliveryFeature(),
      },
      {
        'title': 'Geolocation Services',
        'description': 'Track your rides and deliveries in real time.',
        'image': _categoryImages['Geolocation Services'],
        'widget': const GeolocationFeature(),
      },
      {
        'title': 'Electric Cars',
        'description': 'Eco-friendly electric car rides.',
        'image': _categoryImages['Electric Cars'],
        'widget': const ElectricCarsFeature(),
      },
      {
        'title': 'Women-Only Rides',
        'description': 'Safe rides for women, by women.',
        'image': _categoryImages['Women-Only Rides'],
        'widget': const WomenOnlyFeature(),
      },
      {
        'title': 'Green Points',
        'description': 'Earn points for eco-friendly actions.',
        'image': _categoryImages['Green Points'],
        'widget': const GreenPointsFeature(),
      },
      {
        'title': 'Tree Planting',
        'description': 'Join our tree planting initiatives.',
        'image': _categoryImages['Tree Planting'],
        'widget': const TreePlantingFeature(),
      },
    ];
    return ListView(
      padding: const EdgeInsets.only(top: 0, bottom: 24),
      children: [
        _buildGreetingAndProfile(),
        _buildSearchBar(),
        // Emergency Assistance quick access
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.warning, color: Colors.white),
            label: const Text('Emergency Assistance'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(context).pushNamed('/emergency'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/green_points.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.emoji_events, color: Colors.green, size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Earn Free Rides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              SizedBox(height: 8),
                              Text(
                                'Ride electric cars or bodas to earn green points! 🌱 Accumulate 1,000+ points and redeem for free rides & eco gifts. Help reduce climate change—start earning today!',
                                style: TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.w600, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showMpesaValueDialog,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/icons/mpesa.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.mobile_friendly, color: Colors.green, size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Mpesa Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              SizedBox(height: 8),
                              Text(
                                '🔥 Get 3 discounted rides for only KES 200! Tap to unlock savings.',
                                style: TextStyle(fontSize: 15, color: Colors.green, fontWeight: FontWeight.w600, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Save Every Day',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF222B45)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCategoryCard(categories[0])),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCategoryCard(categories[1])),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'More Ways to Use Nairobi Go',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF222B45)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCategoryCard(categories[2])),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCategoryCard(categories[3])),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Go Anywhere Together',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF222B45)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCategoryCard(categories[4])),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCategoryCard(categories[5])),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Rewards Through Green Points',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF222B45)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildCategoryCard(categories[6])),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCategoryCard(categories[7])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to build a single category card
  Widget _buildCategoryCard(Map<String, dynamic> cat) {
    return GestureDetector(
      onTap: () => _openFeatureContent(cat['title'], cat['widget']),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                cat['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cat['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            if (_showFeatureContent)
              _featureContent ?? const SizedBox.shrink()
            else
              _buildCategories(),
          ],
        ),
      ),
    );
  }
}