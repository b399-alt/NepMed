import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/subscription/domain/entities/subscription_entity.dart';
import '../../features/subscription/presentation/pages/subscription_detail_page.dart';
import '../../features/subscription/presentation/providers/subscription_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final auth = context.read<AuthProvider>();
    final sp = context.read<SubscriptionProvider>();
    if (auth.currentUser != null) sp.loadSubscriptions(auth.currentUser!.id);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) => Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white, elevation: 0,
          title: const Text('My Subscriptions',
              style: TextStyle(color: Color(0xFF1E293B), fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF2196F3),
            unselectedLabelColor: const Color(0xFF94A3B8),
            indicatorColor: const Color(0xFF2196F3), indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: [
              Tab(text: 'Active (' + provider.activeSubscriptions.length.toString() + ')'),
              Tab(text: 'Paused (' + provider.pausedSubscriptions.length.toString() + ')'),
              const Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: provider.isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2196F3)))
            : TabBarView(controller: _tabController, children: [
                _buildList(provider.activeSubscriptions),
                _buildList(provider.pausedSubscriptions),
                _buildList(provider.cancelledSubscriptions),
              ]),
      ),
    );
  }

  Widget _buildList(List<SubscriptionEntity> subs) {
    if (subs.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.subscriptions_outlined, size: 80, color: Colors.grey[300]),
      const SizedBox(height: 16),
      Text('No subscriptions', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
      const SizedBox(height: 8),
      Text('Add medicines from Pharmacy', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
    ]));
    return RefreshIndicator(
      onRefresh: () async => _load(),
      child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: subs.length,
          itemBuilder: (_, i) => _subCard(subs[i])),
    );
  }

  Widget _subCard(SubscriptionEntity sub) {
    final c = sub.status == SubscriptionStatus.active ? const Color(0xFF2196F3)
        : sub.status == SubscriptionStatus.paused ? const Color(0xFFFF9800) : const Color(0xFF9E9E9E);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SubscriptionDetailPage(subscription: sub))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(sub.frequency.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text(sub.totalItems.toString() + ' item(s) every ' + sub.intervalDays.toString() + ' day(s)', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(sub.status.label, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600))),
          ])),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Container(width: 48, height: 48,
                decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.medication, color: Color(0xFF2196F3), size: 24)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(sub.medicineNames, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text('Next: ' + sub.nextDelivery.day.toString() + '/' + sub.nextDelivery.month.toString() + '/' + sub.nextDelivery.year.toString(),
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            ])),
            Text('₹' + sub.discountedTotal.toStringAsFixed(0),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2196F3))),
          ])),
          if (sub.status != SubscriptionStatus.cancelled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
              child: const Row(children: [
                Spacer(),
                Text('View Details', style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.w600, fontSize: 13)),
                Icon(Icons.chevron_right, color: Color(0xFF2196F3), size: 18),
              ]),
            ),
        ]),
      ),
    );
  }
}