import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/subscription/presentation/providers/subscription_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final subProvider = context.watch<SubscriptionProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile',
            style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'U',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user?.fullName ?? 'User',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(user?.email ?? '',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              _statCard('Active\nSubs', '${subProvider.activeSubscriptions.length}', const Color(0xFF2196F3)),
              const SizedBox(width: 12),
              _statCard('Total\nOrders', '${subProvider.subscriptions.length}', const Color(0xFF4CAF50)),
              const SizedBox(width: 12),
              _statCard('Paused\nSubs', '${subProvider.pausedSubscriptions.length}', const Color(0xFFFF9800)),
            ],
          ),

          const SizedBox(height: 24),

          _sectionTitle('Account'),
          _menuCard([
            _menuItem(Icons.person_outline, 'Personal Information', () => _showPersonalInfo(context, user?.fullName ?? '', user?.email ?? '')),
            _menuItem(Icons.notifications_outlined, 'Notifications', () {}),
          ]),

          const SizedBox(height: 16),
          _sectionTitle('Help'),
          _menuCard([
            _menuItem(Icons.help_outline, 'Help & Support', () {}),
            _menuItem(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
            _menuItem(Icons.info_outline, 'About NepMed', () => _showAbout(context)),
          ]),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Log Out',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _confirmLogout(context, auth),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)), textAlign: TextAlign.center),
        ],
      ),
    ),
  );

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
  );

  Widget _menuCard(List<Widget> items) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(children: items),
  );

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) => ListTile(
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: const Color(0xFF2196F3), size: 20),
    ),
    title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
    trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
    onTap: onTap,
  );

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () { Navigator.pop(ctx); auth.logout(); },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPersonalInfo(BuildContext context, String name, String email) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Personal Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoField('Full Name', name),
            const SizedBox(height: 12),
            _infoField('Email', email),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  Widget _infoField(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    ],
  );

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'NepMed',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 NepMed. All rights reserved.',
      children: [const Text('NepMed is a subscription-based medicine delivery app.')],
    );
  }
}
