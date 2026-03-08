import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/bottom_screens/orders.dart';
import 'screens/bottom_screens/pharmacy.dart';
import 'screens/bottom_screens/profile.dart';
import 'services/sensor_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final SensorService _sensorService = SensorService();
  bool _shakeDialogOpen = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const OrdersScreen(),
    const PharmacyScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startSensors();
  }

  void _startSensors() {
    _sensorService.startAll(
      onShakeCallback: _handleShake,
      onTiltCallback: _handleTilt,
    );
  }

  // ── Shake → Logout ─────────────────────────────────────────────────────────
  void _handleShake() {
    if (_shakeDialogOpen || !mounted) return;
    _shakeDialogOpen = true;
    _showShakeLogoutDialog();
  }

  void _showShakeLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        onPopInvokedWithResult: (didPop, _) { if (didPop) _shakeDialogOpen = false; },
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 10),
            Text('Shake Detected!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(children: [
                  Icon(Icons.phone_android, color: Colors.orange, size: 32),
                  SizedBox(width: 12),
                  Expanded(child: Text(
                    'Phone shake detected.\nDo you want to log out?',
                    style: TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                  )),
                ]),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tip: Shake your phone 3 times to quickly log out for privacy.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            OutlinedButton(
              onPressed: () { Navigator.pop(ctx); _shakeDialogOpen = false; },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _shakeDialogOpen = false;
                context.read<AuthProvider>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tilt → Switch Tabs ────────────────────────────────────────────────────
  void _handleTilt(TiltDirection dir) {
    if (!mounted) return;
    setState(() {
      if (dir == TiltDirection.right && _currentIndex < _screens.length - 1) {
        _currentIndex++;
        _showTiltSnack(dir);
      } else if (dir == TiltDirection.left && _currentIndex > 0) {
        _currentIndex--;
        _showTiltSnack(dir);
      }
    });
  }

  void _showTiltSnack(TiltDirection dir) {
    final label = ['Home', 'Orders', 'Pharmacy', 'Profile'][_currentIndex];
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(children: [
          Icon(dir == TiltDirection.right ? Icons.arrow_forward : Icons.arrow_back, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text('Tilted to $label', style: const TextStyle(fontWeight: FontWeight.w500)),
        ]),
        backgroundColor: const Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 72),
      ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sensorService.stopAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2196F3),
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.subscriptions_outlined), activeIcon: Icon(Icons.subscriptions), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.local_pharmacy_outlined), activeIcon: Icon(Icons.local_pharmacy), label: 'Pharmacy'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
