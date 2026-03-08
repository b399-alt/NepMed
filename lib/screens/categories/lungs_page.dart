import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/medicine/domain/entities/medicine_entity.dart';
import '../../features/medicine/presentation/providers/medicine_provider.dart';

class LungsPage extends StatelessWidget {
  const LungsPage({super.key});

  static const _tips = [
    'Deep breathe 5 minutes daily to strengthen lung capacity.',
    'Avoid smoking & second-hand smoke to protect lung tissue.',
    'Exercise regularly — 30 min cardio improves lung function.',
    'Keep indoor air clean; use air purifiers if needed.',
    'Stay hydrated to keep mucous membranes moist.',
    'Get annual flu vaccination to prevent respiratory infections.',
  ];

  static const _facts = [
    {'icon': Icons.air, 'label': 'Breath/day', 'value': '20,000+'},
    {'icon': Icons.opacity, 'label': 'O₂ capacity', 'value': '6 liters'},
    {'icon': Icons.favorite, 'label': 'Lung weight', 'value': '~1.1 kg'},
    {'icon': Icons.bar_chart, 'label': 'Alveoli', 'value': '480M'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildFactsRow()),
          SliverToBoxAdapter(child: _buildHealthScore()),
          SliverToBoxAdapter(child: _buildTips()),
          SliverToBoxAdapter(child: _buildMedicinesSection(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) => SliverAppBar(
    expandedHeight: 220,
    pinned: true,
    backgroundColor: const Color(0xFFFF6B6B),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    ),
    flexibleSpace: FlexibleSpaceBar(
      title: const Text('Lungs Health',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      background: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Decorative circles
          Positioned(right: -30, top: -20,
            child: Container(width: 150, height: 150,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle))),
          Positioned(left: -20, bottom: 20,
            child: Container(width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle))),
          // Icon
          const Positioned(right: 24, bottom: 40,
            child: Icon(Icons.air, color: Colors.white, size: 80)),
          // Subtitle
          const Positioned(bottom: 56, left: 16,
            child: Text('Breathe better. Live longer.',
                style: TextStyle(color: Colors.white70, fontSize: 13))),
        ],
      ),
    ),
  );

  Widget _buildFactsRow() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Row(
      children: _facts.map((f) => Expanded(
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Column(
            children: [
              Icon(f['icon'] as IconData, color: const Color(0xFFFF6B6B), size: 22),
              const SizedBox(height: 6),
              Text(f['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
              const SizedBox(height: 2),
              Text(f['label'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)), textAlign: TextAlign.center),
            ],
          ),
        ),
      )).toList(),
    ),
  );

  Widget _buildHealthScore() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFF5F5), Color(0xFFFFECEC)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.health_and_safety, color: Color(0xFFFF6B6B)),
              SizedBox(width: 8),
              Text('Lung Health Indicators', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 16),
          _healthBar('Peak Flow', 0.75, 'Normal (>400 L/min)'),
          const SizedBox(height: 10),
          _healthBar('Oxygen Saturation', 0.96, 'Healthy (95-100%)'),
          const SizedBox(height: 10),
          _healthBar('Respiratory Rate', 0.65, 'Normal (12-20/min)'),
        ],
      ),
    ),
  );

  Widget _healthBar(String label, double value, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text('${(value * 100).toInt()}%', style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: const Color(0xFFFFCDD2),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
          minHeight: 8,
        ),
      ),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
    ],
  );

  Widget _buildTips() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lung Care Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
        const SizedBox(height: 12),
        ..._tips.asMap().entries.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(color: Color(0xFFFFECEC), shape: BoxShape.circle),
                child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold, fontSize: 13))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(e.value, style: const TextStyle(color: Color(0xFF475569), fontSize: 14, height: 1.4))),
            ],
          ),
        )),
      ],
    ),
  );

  Widget _buildMedicinesSection(BuildContext context) {
    return Consumer2<MedicineProvider, CartProvider>(
      builder: (context, medProvider, cart, _) {
        final meds = medProvider.medicines
            .where((m) => m.category.toLowerCase().contains('lung') || m.category.toLowerCase().contains('breath'))
            .toList();

        // Also show allergy/infection meds that affect breathing
        final related = medProvider.medicines
            .where((m) => m.category == 'Allergy' || m.category == 'Antibiotics')
            .take(3)
            .toList();
        final all = [...meds, ...related.where((r) => !meds.any((m) => m.id == r.id))];

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Recommended Medicines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text('${all.length} product(s) for respiratory health', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
              const SizedBox(height: 12),
              if (all.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No medicines found for this category', style: TextStyle(color: Color(0xFF94A3B8))),
                ))
              else
                ...all.map((med) => _medicineCard(context, med, cart)),
            ],
          ),
        );
      },
    );
  }

  Widget _medicineCard(BuildContext context, MedicineEntity med, CartProvider cart) {
    final inCart = cart.isInCart(med.id);
    final qty = cart.quantityOf(med.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: inCart ? Border.all(color: const Color(0xFFFF6B6B), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFFFECEC), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.medication, color: Color(0xFFFF6B6B), size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(med.dosage, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                const SizedBox(height: 4),
                Text('₹${med.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFFF6B6B))),
              ],
            ),
          ),
          if (inCart)
            Row(children: [
              _qBtn(Icons.remove, () => cart.removeMedicine(med.id), Colors.red),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              _qBtn(Icons.add, () => cart.updateQuantity(med.id, qty + 1), const Color(0xFFFF6B6B)),
            ])
          else
            GestureDetector(
              onTap: () {
                cart.addMedicine(med);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${med.name} added to cart'),
                  backgroundColor: const Color(0xFFFF6B6B),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFFF6B6B), borderRadius: BorderRadius.circular(8)),
                child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _qBtn(IconData icon, VoidCallback onTap, Color color) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, size: 16, color: color),
    ),
  );
}
