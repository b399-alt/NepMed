import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/medicine/presentation/providers/medicine_provider.dart';
import '../../features/subscription/presentation/providers/subscription_provider.dart';
import '../../services/sensor_service.dart';
import '../../utils/responsive.dart';
import '../categories/lungs_page.dart';
import '../categories/kidney_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<Map<String, dynamic>> _categories = [
    {'name': 'Lungs',     'icon': Icons.air,              'color': Color(0xFFFF6B6B), 'hasPage': true},
    {'name': 'Kidney',    'icon': Icons.water_drop,        'color': Color(0xFF4ECDC4), 'hasPage': true},
    {'name': 'Eye',       'icon': Icons.visibility,        'color': Color(0xFFFFD93D), 'hasPage': false},
    {'name': 'Heart',     'icon': Icons.favorite,          'color': Color(0xFFFF6B6B), 'hasPage': false},
    {'name': 'Infection', 'icon': Icons.coronavirus,       'color': Color(0xFF6C5CE7), 'hasPage': false},
    {'name': 'Bone',      'icon': Icons.accessibility_new, 'color': Color(0xFFA29BFE), 'hasPage': false},
  ];

  final SensorService _sensorService = SensorService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth    = context.read<AuthProvider>();
      final subProv = context.read<SubscriptionProvider>();
      final medProv = context.read<MedicineProvider>();
      if (auth.currentUser != null) subProv.loadSubscriptions(auth.currentUser!.id);
      medProv.loadMedicines();
    });
  }

  void _onCategoryTap(Map<String, dynamic> cat) {
    final name = cat['name'] as String;
    if (name == 'Lungs') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LungsPage()));
    } else if (name == 'Kidney') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const KidneyPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$name page coming soon!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: cat['color'] as Color,
        duration: const Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTab     = Responsive.isTablet(context);
    final auth      = context.watch<AuthProvider>();
    final subProv   = context.watch<SubscriptionProvider>();
    final medProv   = context.watch<MedicineProvider>();
    final userName  = auth.currentUser?.fullName.split(' ').first ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTab ? 28 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, $userName!',
                          style: TextStyle(fontSize: Responsive.scale(context, 22), fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
                      Text('Stay healthy, stay strong',
                          style: TextStyle(fontSize: Responsive.scale(context, 13), color: const Color(0xFF64748B))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Responsive.scale(context, 16)),

              // ── Step Counter Card ───────────────────────────────────────────
              StreamBuilder<int>(
                stream: _sensorService.stepsStream,
                initialData: _sensorService.steps,
                builder: (context, snap) {
                  final steps = snap.data ?? 0;
                  final pct   = (steps / 10000).clamp(0.0, 1.0);
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
                          child: const Icon(Icons.directions_walk, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Today\'s Steps', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('$steps', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                                  const Text(' / 10,000', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () { _sensorService.resetSteps(); setState(() {}); },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('Reset', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: Responsive.scale(context, 16)),

              // ── Active subscription banner ───────────────────────────────────
              if (subProv.activeSubscriptions.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1976D2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Active Subscriptions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('${subProv.activeSubscriptions.length} subscription(s) running', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),

              if (subProv.activeSubscriptions.isNotEmpty) SizedBox(height: Responsive.scale(context, 16)),

              // ── Quick stats ──────────────────────────────────────────────────
              Row(
                children: [
                  _statCard('Active\nSubs', '${subProv.activeSubscriptions.length}', Icons.subscriptions, const Color(0xFF2196F3)),
                  const SizedBox(width: 12),
                  _statCard('Medicines\nAvailable', '${medProv.medicines.length}', Icons.medication, const Color(0xFF4CAF50)),
                ],
              ),

              SizedBox(height: Responsive.scale(context, 24)),

              // ── Categories ──────────────────────────────────────────────────
              Text('Medicine Categories',
                  style: TextStyle(fontSize: Responsive.scale(context, 18), fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: Responsive.scale(context, 12)),
              SizedBox(
                height: Responsive.scale(context, 100),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final cat      = _categories[i];
                    final hasPage  = cat['hasPage'] as bool;
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () => _onCategoryTap(cat),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: Responsive.scale(context, 28),
                                  backgroundColor: (cat['color'] as Color).withValues(alpha: 0.15),
                                  child: Icon(cat['icon'] as IconData,
                                      size: Responsive.scale(context, 28), color: cat['color'] as Color),
                                ),
                                if (hasPage)
                                  Positioned(
                                    right: 0, bottom: 0,
                                    child: Container(
                                      width: 14, height: 14,
                                      decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                                      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 9),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: Responsive.scale(context, 6)),
                            Text(cat['name'] as String,
                                style: TextStyle(fontSize: Responsive.scale(context, 12), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: Responsive.scale(context, 24)),

              // ── Popular medicines ────────────────────────────────────────────
              Text('Popular Medicines',
                  style: TextStyle(fontSize: Responsive.scale(context, 18), fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: Responsive.scale(context, 12)),

              if (medProv.isLoading)
                const Center(child: CircularProgressIndicator(color: Color(0xFF2196F3)))
              else if (medProv.medicines.isEmpty)
                const Center(child: Text('No medicines available', style: TextStyle(color: Color(0xFF94A3B8))))
              else
                SizedBox(
                  height: Responsive.scale(context, 180),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: medProv.medicines.take(6).length,
                    itemBuilder: (context, i) {
                      final med = medProv.medicines[i];
                      return Container(
                        width: Responsive.scale(context, 140),
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: Responsive.scale(context, 80),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F4FF),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: Center(child: Icon(Icons.medication, size: Responsive.scale(context, 40), color: Colors.blue[300])),
                            ),
                            Padding(
                              padding: EdgeInsets.all(Responsive.scale(context, 8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(med.name,
                                      style: TextStyle(fontSize: Responsive.scale(context, 12), fontWeight: FontWeight.bold),
                                      maxLines: 1, overflow: TextOverflow.ellipsis),
                                  SizedBox(height: Responsive.scale(context, 2)),
                                  Text('\u20b9${med.price.toStringAsFixed(0)}',
                                      style: TextStyle(fontSize: Responsive.scale(context, 12), color: const Color(0xFF2196F3), fontWeight: FontWeight.w600)),
                                  SizedBox(height: Responsive.scale(context, 4)),
                                  Text(med.category,
                                      style: TextStyle(fontSize: Responsive.scale(context, 10), color: Colors.grey[500]),
                                      maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              SizedBox(height: Responsive.scale(context, 24)),

              // ── Subscription benefits ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.verified, color: Color(0xFF2196F3), size: 22),
                      SizedBox(width: 8),
                      Text('Why Subscribe?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                    ]),
                    const SizedBox(height: 12),
                    _benefit(Icons.local_shipping, 'Free delivery on every order'),
                    _benefit(Icons.discount,       'Up to 15% discount on subscriptions'),
                    _benefit(Icons.schedule,       'Never miss your medicines'),
                    _benefit(Icons.cancel,         'Cancel anytime, no questions asked'),
                  ],
                ),
              ),

              SizedBox(height: Responsive.scale(context, 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _benefit(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(icon, color: const Color(0xFF4CAF50), size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13))),
    ]),
  );
}
