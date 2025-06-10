import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _donationAmountController = TextEditingController();
  final TextEditingController _donorPhoneController = TextEditingController();
  bool _isSending = false;
  bool _alertSent = false;
  bool _isDonating = false;
  bool _donationSuccess = false;

  Future<void> _sendEmergencyAlert() async {
    final user = FirebaseAuth.instance.currentUser;
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe the emergency.')));
      return;
    }
    setState(() {
      _isSending = true;
      _alertSent = false;
    });
    // Store in Firestore
    await FirebaseFirestore.instance.collection('emergencies').add({
      'userId': user?.uid,
      'userName': user?.displayName ?? user?.email ?? 'Anonymous',
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
    // Call backend to send SMS
    final response = await http.post(
      Uri.parse('http://192.168.0.100:3000/api/emergency-alert'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userPhone': user?.phoneNumber,
        'userName': user?.displayName ?? user?.email ?? 'Anonymous',
        'location': null, // Optionally add location
        'description': description,
      }),
    );
    setState(() {
      _isSending = false;
      _alertSent = response.statusCode == 200;
    });
    if (_alertSent) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alert sent to emergency contacts and dispatch!')));
      _descriptionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send alert. Try again.')));
    }
  }

  Future<void> _donateToVictims() async {
    final amount = _donationAmountController.text.trim();
    final phone = _donorPhoneController.text.trim();
    if (amount.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter amount and your M-Pesa number.')));
      return;
    }
    setState(() {
      _isDonating = true;
      _donationSuccess = false;
    });
    final response = await http.post(
      Uri.parse('http://192.168.0.100:3000/api/donate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phone,
        'amount': amount,
      }),
    );
    setState(() {
      _isDonating = false;
      _donationSuccess = response.statusCode == 200 && jsonDecode(response.body)['success'] == true;
    });
    if (_donationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('STK Push sent! Enter your M-Pesa PIN to complete.')));
      _donationAmountController.clear();
      _donorPhoneController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send STK Push. Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Assistance')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Describe your emergency and alert your contacts and dispatch. You can also donate to support victims.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Describe the emergency',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: _isSending ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.warning, color: Colors.white),
                label: const Text('Send Emergency Alert'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _isSending ? null : _sendEmergencyAlert,
              ),
              if (_alertSent)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Alert sent to emergency contacts and dispatch!', style: TextStyle(color: Colors.green)),
                ),
              const Divider(height: 40),
              const Text('Support Victims:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: _donationAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (KES)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _donorPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Your M-Pesa Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isDonating ? null : _donateToVictims,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isDonating ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Donate'),
              ),
              if (_donationSuccess)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Thank you for your donation! STK Push sent.', style: TextStyle(color: Colors.green)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
