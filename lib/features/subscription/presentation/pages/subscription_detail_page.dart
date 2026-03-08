import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/subscription_entity.dart';
import '../providers/subscription_provider.dart';

class SubscriptionDetailPage extends StatelessWidget {
  final SubscriptionEntity subscription;
  const SubscriptionDetailPage({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        final sub = provider.subscriptions.firstWhere(
          (s) => s.id == subscription.id,
          orElse: () => subscription,
        );
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Subscription Details',
                style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _statusCard(sub),
              const SizedBox(height: 16),
              _deliveryCard(sub),
              const SizedBox(height: 16),
              _medicinesCard(sub),
              const SizedBox(height: 16),
              _priceCard(sub),
              const SizedBox(height: 24),
              if (sub.status != SubscriptionStatus.cancelled)
                _actionButtons(context, provider, sub),
            ],
          ),
        );
      },
    );
  }

  Widget _statusCard(SubscriptionEntity sub) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: sub.status == SubscriptionStatus.active
            ? [const Color(0xFF2196F3), const Color(0xFF1976D2)]
            : sub.status == SubscriptionStatus.paused
                ? [const Color(0xFFFF9800), const Color(0xFFF57C00)]
                : [const Color(0xFF9E9E9E), const Color(0xFF757575)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(sub.status.label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            const Spacer(),
            Text(sub.frequency.label,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        Text('${sub.totalItems} medicine(s)',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('₹${sub.discountedTotal.toStringAsFixed(0)} per delivery',
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Text(
              'Next delivery: ${_formatDate(sub.nextDelivery)}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _deliveryCard(SubscriptionEntity sub) => _infoCard('Delivery Details', [
    _infoRow(Icons.location_on, 'Address', sub.deliveryAddress),
    const SizedBox(height: 12),
    _infoRow(Icons.phone, 'Phone', sub.deliveryPhone),
    const SizedBox(height: 12),
    _infoRow(Icons.schedule, 'Interval', 'Every ${sub.intervalDays} day(s)'),
    const SizedBox(height: 12),
    _infoRow(Icons.date_range, 'Started', _formatDate(sub.startDate)),
    if (sub.notes != null && sub.notes!.isNotEmpty) ...[
      const SizedBox(height: 12),
      _infoRow(Icons.note, 'Notes', sub.notes!),
    ],
  ]);

  Widget _medicinesCard(SubscriptionEntity sub) => _infoCard('Medicines', [
    ...sub.items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medication, color: Color(0xFF2196F3), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.medicineName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text('${item.category} • Qty: ${item.quantity}',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          Text('₹${item.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
        ],
      ),
    )),
  ]);

  Widget _priceCard(SubscriptionEntity sub) => _infoCard('Price Summary', [
    _priceRow('Subtotal', '₹${sub.totalPrice.toStringAsFixed(0)}'),
    if (sub.discountPercent > 0) ...[
      const SizedBox(height: 8),
      _priceRow('Discount (${sub.discountPercent}%)',
          '-₹${(sub.totalPrice * sub.discountPercent / 100).toStringAsFixed(0)}',
          color: const Color(0xFF4CAF50)),
    ],
    const Divider(height: 24),
    _priceRow('Total per delivery', '₹${sub.discountedTotal.toStringAsFixed(0)}',
        isTotal: true),
  ]);

  Widget _actionButtons(BuildContext context, SubscriptionProvider provider, SubscriptionEntity sub) =>
    Column(
      children: [
        if (sub.status == SubscriptionStatus.active)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.pause_circle_outline),
              label: const Text('Pause Subscription'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF9800),
                side: const BorderSide(color: Color(0xFFFF9800)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _confirmAction(context, provider, sub, 'pause'),
            ),
          ),
        if (sub.status == SubscriptionStatus.paused)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Resume Subscription'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () => _confirmAction(context, provider, sub, 'resume'),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel Subscription'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF44336),
              side: const BorderSide(color: Color(0xFFF44336)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _confirmAction(context, provider, sub, 'cancel'),
          ),
        ),
      ],
    );

  Future<void> _confirmAction(BuildContext context, SubscriptionProvider provider,
      SubscriptionEntity sub, String action) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${action.capitalize()} Subscription'),
        content: Text('Are you sure you want to $action this subscription?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(action.capitalize(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      bool success = false;
      if (action == 'cancel') success = await provider.cancelSubscription(sub.id);
      if (action == 'pause') success = await provider.pauseSubscription(sub.id);
      if (action == 'resume') success = await provider.resumeSubscription(sub.id);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Subscription ${action}d successfully'),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  Widget _infoCard(String title, List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );

  Widget _infoRow(IconData icon, String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: const Color(0xFF2196F3)),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    ],
  );

  Widget _priceRow(String label, String value, {Color? color, bool isTotal = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(
        fontSize: isTotal ? 16 : 14,
        fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
        color: isTotal ? const Color(0xFF1E293B) : const Color(0xFF64748B),
      )),
      Text(value, style: TextStyle(
        fontSize: isTotal ? 18 : 14,
        fontWeight: FontWeight.bold,
        color: color ?? (isTotal ? const Color(0xFF2196F3) : const Color(0xFF1E293B)),
      )),
    ],
  );

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}';
}

extension StringCapitalize on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
