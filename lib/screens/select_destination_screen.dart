// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectDestinationScreen extends StatefulWidget {
  final String? initialQuery;
  const SelectDestinationScreen({super.key, this.initialQuery});

  @override
  State<SelectDestinationScreen> createState() => _SelectDestinationScreenState();
}

class _SelectDestinationScreenState extends State<SelectDestinationScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  final TextEditingController _destinationController = TextEditingController();
  late GooglePlace _googlePlace;
  List<AutocompletePrediction> _predictions = [];
  bool _showTripOptions = false;
  String? _selectedTripType;

  // Mock data for available public transport options (Bus, Matatu, Boda only, no route)
  final List<Map<String, dynamic>> _availableTrips = [
    {
      'type': 'Bus',
      'price': 'KES 80',
      'fullness': '50%',
      'seatsAvailable': 20,
      'departure': '10 min',
      'image': 'assets/images/bus_option.jpg',
    },
    {
      'type': 'Matatu',
      'price': 'KES 120',
      'fullness': 'Full',
      'seatsAvailable': 0,
      'departure': 'Departing',
      'image': 'assets/images/matatu_option.jpg',
    },
    {
      'type': 'Boda',
      'price': 'KES 200',
      'fullness': 'N/A',
      'seatsAvailable': 1,
      'departure': 'Ready',
      'image': 'assets/images/boda_option.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initLocation();
    _googlePlace = GooglePlace(dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '');
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _destinationController.text = widget.initialQuery!;
      // Show predictions immediately for the initial query
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onDestinationChanged(widget.initialQuery!);
      });
    }
    // Listen to text changes for live autocomplete
    _destinationController.addListener(() {
      if (!_showTripOptions) {
        _onDestinationChanged(_destinationController.text);
      }
    });
  }

  Future<void> _initLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onDestinationChanged(String value) async {
    if (value.isEmpty) {
      setState(() => _predictions = []);
      return;
    }
    final result = await _googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null) {
      setState(() => _predictions = result.predictions!);
    }
  }

  void _showTripOptionsSheet() {
    setState(() {
      _showTripOptions = true;
    });
  }

  void _confirmRide() async {
    String phoneNumber = '';
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter M-Pesa Number'),
          content: TextField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: 'e.g. 07XXXXXXXX'),
            onChanged: (value) => phoneNumber = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (phoneNumber.isNotEmpty) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
    if (phoneNumber.isEmpty) return;
    await _startMpesaPayment(phoneNumber);
  }

  Future<void> _startMpesaPayment(String phoneNumber) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // TODO: Replace this with your real backend call
    final success = await _realMpesaStkPush(phoneNumber, _selectedTripType);

    
    Navigator.of(context).pop(); // Remove loading dialog

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Successful'),
          content: Text('Your $_selectedTripType booking is confirmed and paid!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Failed'),
          content: const Text('There was a problem with your M-Pesa payment. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Simulate a real M-Pesa STK push (replace with real API call to your backend)
  Future<bool> _realMpesaStkPush(String phone, String? tripType) async {
    final trip = _availableTrips.firstWhere((t) => t['type'] == tripType);
    final response = await http.post(
      Uri.parse('http://192.168.0.100:3000/api/stkpush'), // <-- Replace with your backend IP
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phone,
        'amount': trip['price'].replaceAll(RegExp(r'[^0-9]'), ''),
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  }

  Future<void> _selectPrediction(AutocompletePrediction prediction) async {
    final details = await _googlePlace.details.get(prediction.placeId!);
    if (details != null && details.result != null && details.result!.geometry != null) {
      final loc = details.result!.geometry!.location;
      setState(() {
        _destinationPosition = LatLng(loc!.lat!, loc.lng!);
        _destinationController.text = details.result!.name ?? '';
        _predictions = [];
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_destinationPosition!));
      _showTripOptionsSheet();
    }
  }

  // Helper to get image asset for each trip type
  String _getTripImage(String type) {
    switch (type) {
      case 'Bus':
        return 'assets/images/bus_option.jpg';
      case 'Matatu':
        return 'assets/images/matatu_option.jpg';
      case 'Boda':
        return 'assets/images/boda_option.jpg';
      default:
        return 'assets/images/electric_car.jpg';
    }
  }

  // Mock data for available cars (simulate dynamic availability)
  int getAvailableForType(String type) {
    return 1; // Always 1 for demo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Destination')),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: _currentPosition!, zoom: 14),
                  markers: {
                    if (_currentPosition != null)
                      Marker(markerId: const MarkerId('current'), position: _currentPosition!, infoWindow: const InfoWindow(title: 'You are here')),
                    if (_destinationPosition != null)
                      Marker(markerId: const MarkerId('destination'), position: _destinationPosition!, infoWindow: const InfoWindow(title: 'Destination')),
                  },
                ),
          // Show autocomplete overlay below the search bar
          if (_destinationController.text.isNotEmpty && !_showTripOptions && _predictions.isNotEmpty)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _predictions.length,
                  itemBuilder: (context, index) {
                    final p = _predictions[index];
                    return ListTile(
                      title: Text(p.description ?? ''),
                      onTap: () => _selectPrediction(p),
                    );
                  },
                ),
              ),
            ),
          // Trip options sheet (ALWAYS visible, overlays map, covers 55% of screen height)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.55, // 55% of screen height
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Choose a Trip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    Row(
                      children: _availableTrips.map((trip) => Expanded(
                        child: _TripOptionCard(
                          type: trip['type'],
                          price: trip['price'],
                          eta: trip['departure'],
                          available: trip['seatsAvailable'],
                          image: _getTripImage(trip['type']),
                          fullness: trip['fullness'],
                          selected: _selectedTripType == trip['type'],
                          onTap: () => setState(() => _selectedTripType = trip['type']),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedTripType == null ? null : _confirmRide,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        child: const Text('Confirm Ride', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Place this outside the _SelectDestinationScreenState class
class _TripOptionCard extends StatelessWidget {
  final String type;
  final String price;
  final String eta;
  final int available;
  final String image;
  final String fullness;
  final bool selected;
  final VoidCallback onTap;

  const _TripOptionCard({
    required this.type,
    required this.price,
    required this.eta,
    required this.available,
    required this.image,
    required this.fullness,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Colors.green[50] : Colors.grey[100],
          border: Border.all(color: selected ? Colors.green : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 48,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(price, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 4),
            if (fullness.isNotEmpty) Text('Fullness: $fullness', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            Text('Seats: $available', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text('Departs: $eta', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
