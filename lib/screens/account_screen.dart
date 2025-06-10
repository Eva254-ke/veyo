import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green[100],
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null ? const Icon(Icons.person, size: 40, color: Colors.green) : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                if (user != null) _FirestoreUserData(userId: user.uid),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildAccountTile(Icons.settings, 'Settings', onTap: () => _showEditProfileDialog(context, user)),
          _buildAccountTile(Icons.message, 'Messages', onTap: () => _showSendMessageDialog(context, user)),
          _buildAccountTile(Icons.local_offer, 'Promotions', onTap: () => _showPromotionsDialog(context)),
          _buildAccountTile(Icons.account_balance_wallet, 'Wallet', onTap: () => _showWalletDialog(context, user)),
          _buildAccountTile(Icons.history, 'Activity', onTap: () {}),
          _buildAccountTile(Icons.gavel, 'Legal', onTap: () {}),
          _buildAccountTile(Icons.help_outline, 'Help', onTap: () {}),
          _buildAccountTile(Icons.more_horiz, 'More', onTap: () {}),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Optionally navigate to login screen
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(BuildContext context, User? user) {
    final nameController = TextEditingController(text: user?.displayName ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (user != null) {
                await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                  'displayName': nameController.text,
                  'email': user.email,
                }, SetOptions(merge: true));
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSendMessageDialog(BuildContext context, User? user) {
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Message'),
        content: TextField(
          controller: messageController,
          decoration: const InputDecoration(labelText: 'Message'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (user != null && messageController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('messages').add({
                  'userId': user.uid,
                  'message': messageController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showPromotionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Promotions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.local_offer, color: Colors.orange),
              title: Text('20% Off Your Next Ride'),
              subtitle: Text('Use code: RIDE20. Valid until June 30, 2025.'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.card_giftcard, color: Colors.green),
              title: Text('Earn 100 Green Points'),
              subtitle: Text('Complete 5 rides this week to earn bonus points!'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star, color: Colors.purple),
              title: Text('Refer a Friend'),
              subtitle: Text('Get KES 100 wallet credit for every friend who joins.'),
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wallet'),
        content: user == null
            ? const Text('Sign in to view your wallet.')
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('wallets').doc(user.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
                  }
                  double balance = 0.0;
                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null && data['balance'] != null) {
                      balance = (data['balance'] as num).toDouble();
                    }
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, color: Colors.green, size: 32),
                          const SizedBox(width: 12),
                          Text('KES ${balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(balance == 0 ? 'No cash yet. Top up via Mpesa to add funds.' : 'Your wallet balance.'),
                    ],
                  );
                },
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _FirestoreUserData extends StatelessWidget {
  final String userId;
  const _FirestoreUserData({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('No profile data found.');
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          children: [
            if (data['displayName'] != null)
              Text('Name: ${data['displayName']}'),
            if (data['email'] != null)
              Text('Email: ${data['email']}'),
          ],
        );
      },
    );
  }
}
