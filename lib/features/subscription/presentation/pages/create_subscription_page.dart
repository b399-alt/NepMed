import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/subscription_entity.dart';
import '../providers/subscription_provider.dart';

class CreateSubscriptionPage extends StatefulWidget {
  const CreateSubscriptionPage({super.key});

  @override
  State<CreateSubscriptionPage> createState() => _CreateSubscriptionPageState();
}

class _CreateSubscriptionPageState extends State<CreateSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  SubscriptionFrequency _frequency = SubscriptionFrequency.monthly;
  int _customDays = 7;
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _loading = false;

  final Map<SubscriptionFrequency, Map<String, dynamic>> _freqData = {
    SubscriptionFrequency.daily: {'icon': Icons.today, 'color': const Color(0xFF9C27B0)},
    SubscriptionFrequency.weekly: {'icon': Icons.calendar_view_week, 'color': const Color(0xFF2196F3)},
    SubscriptionFrequency.biweekly: {'icon': Icons.view_week, 'color': const Color(0xFF00BCD4)},
    SubscriptionFrequency.monthly: {'icon': Icons.calendar_month, 'color': const Color(0xFF4CAF50)},
    SubscriptionFrequency.custom: {'icon': Icons.edit_calendar, 'color': const Color(0xFFFF9800)},
  };

  @override
  void dispose() {
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  int get _intervalDays => _frequency == SubscriptionFrequency.custom
      ? _customDays
      : _frequency.defaultDays;

  int get _discountPercent => _frequency.discountPercent;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final totalBeforeDiscount = cart.totalPrice;
    final discount = _discountPercent;
    final finalTotal = totalBeforeDiscount * (1 - discount / 100);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Create Subscription',
            style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Cart summary
            _buildCard('Your Medicines (${cart.itemCount} items)', [
              ...cart.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.medication, color: Color(0xFF2196F3), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item.medicineName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                    Text('x${item.quantity}', style: const TextStyle(color: Color(0xFF64748B))),
                    const SizedBox(width: 8),
                    Text('₹${item.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                  ],
                ),
              )),
            ]),

            const SizedBox(height: 16),

            // Frequency selection
            _buildCard('Delivery Frequency', [
              ...SubscriptionFrequency.values.map((freq) {
                final data = _freqData[freq]!;
                final isSelected = _frequency == freq;
                return GestureDetector(
                  onTap: () => setState(() => _frequency = freq),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? (data['color'] as Color).withOpacity(0.1) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? (data['color'] as Color) : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(data['icon'] as IconData, color: data['color'] as Color, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(freq.label,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? data['color'] as Color : const Color(0xFF1E293B))),
                              if (freq.discountPercent > 0)
                                Text('${freq.discountPercent}% discount',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF4CAF50))),
                              if (freq != SubscriptionFrequency.custom)
                                Text('Every ${freq.defaultDays} day(s)',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        if (isSelected) Icon(Icons.check_circle, color: data['color'] as Color),
                      ],
                    ),
                  ),
                );
              }),
              if (_frequency == SubscriptionFrequency.custom) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Every  ', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: _customDays.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (v) => setState(() => _customDays = int.tryParse(v) ?? 7),
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          if (n == null || n < 1) return '≥1';
                          return null;
                        },
                      ),
                    ),
                    const Text('  days', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ]),

            const SizedBox(height: 16),

            // Delivery info
            _buildCard('Delivery Information', [
              TextFormField(
                controller: _addressCtrl,
                maxLines: 2,
                validator: (v) => v!.trim().isEmpty ? 'Address required' : null,
                decoration: _inputDecor('Delivery Address', Icons.location_on),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v!.trim().isEmpty) return 'Phone required';
                  if (v.trim().length < 10) return 'Enter valid phone';
                  return null;
                },
                decoration: _inputDecor('Contact Phone', Icons.phone),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesCtrl,
                decoration: _inputDecor('Special Instructions (optional)', Icons.note),
              ),
            ]),

            const SizedBox(height: 16),

            // Price summary
            _buildCard('Price Summary', [
              _priceRow('Subtotal', '₹${totalBeforeDiscount.toStringAsFixed(0)}'),
              if (discount > 0) ...[
                const SizedBox(height: 8),
                _priceRow('${_frequency.label} Discount ($discount%)',
                    '-₹${(totalBeforeDiscount * discount / 100).toStringAsFixed(0)}',
                    color: const Color(0xFF4CAF50)),
              ],
              const SizedBox(height: 8),
              _priceRow('Delivery every $_intervalDays day(s)', 'Free',
                  color: const Color(0xFF4CAF50)),
              const Divider(height: 24),
              _priceRow('Total per delivery', '₹${finalTotal.toStringAsFixed(0)}', isTotal: true),
            ]),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Confirm Subscription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty. Add medicines first.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final subProvider = context.read<SubscriptionProvider>();

    final success = await subProvider.createSubscription(
      userId: auth.currentUser?.id ?? 'guest',
      items: List.from(cart.items),
      frequency: _frequency,
      intervalDays: _intervalDays,
      deliveryAddress: _addressCtrl.text.trim(),
      deliveryPhone: _phoneCtrl.text.trim(),
      discountPercent: _discountPercent,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    setState(() => _loading = false);

    if (mounted) {
      if (success) {
        cart.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription created successfully!'),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(subProvider.errorMessage ?? 'Failed'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildCard(String title, List<Widget> children) => Container(
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

  InputDecoration _inputDecor(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: const Color(0xFF2196F3)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2)),
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
  );

  Widget _priceRow(String label, String value, {Color? color, bool isTotal = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? const Color(0xFF1E293B) : const Color(0xFF64748B))),
      Text(value, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: FontWeight.bold, color: color ?? (isTotal ? const Color(0xFF2196F3) : const Color(0xFF1E293B)))),
    ],
  );
}
