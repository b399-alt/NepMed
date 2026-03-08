import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/medicine/domain/entities/medicine_entity.dart';
import '../../features/medicine/presentation/providers/medicine_provider.dart';

class KidneyPage extends StatelessWidget {
  const KidneyPage({super.key});

  static const _tips = [
    'Drink 8–10 glasses of water daily to flush toxins.',
    'Reduce salt intake — excess sodium strains kidneys.',
    'Limit processed foods high in phosphorus and potassium.',
    'Control blood pressure — hypertension is the #1 kidney killer.',
    'Manage blood sugar — diabetes causes 44% of kidney failure cases.',
    'Avoid overuse of painkillers (NSAIDs) — they damage kidney tissue.',
  ];

  static const _facts = [
    {'icon': Icons.water_drop, 'label': 'Filter/day', 'value': '200L'},
    {'icon': Icons.bloodtype, 'label': 'Blood/day', 'value': '150L'},
    {'icon': Icons.science, 'label': 'Nephrons', 'value': '1M each'},
    {'icon': Icons.timer, 'label': 'Clean blood', 'value': '30 min'},
  ];

  static const _stageData = [
    {'stage': 'Stage 1', 'desc': 'Normal/High GFR (≥90)', 'color': 0xFF4CAF50, 'pct': 0.95},
    {'stage': 'Stage 2', 'desc': 'Mildly Reduced (60-89)', 'color': 0xFF8BC34A, 'pct': 0.75},
    {'stage': 'Stage 3', 'desc': 'Moderately Reduced (30-59)', 'color': 0xFFFF9800, 'pct': 0.50},
    {'stage': 'Stage 4', 'desc': 'Severely Reduced (15-29)', 'color': 0xFFFF5722, 'pct': 0.25},
    {'stage': 'Stage 5', 'desc': 'Kidney Failure (<15)', 'color': 0xFFF44336, 'pct': 0.10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildFactsRow()),
          SliverToBoxAdapter(child: _buildKidneyStages()),
          SliverToBoxAdapter(child: _buildHydrationTracker()),
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
    backgroundColor: const Color(0xFF4ECDC4),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    ),
    flexibleSpace: FlexibleSpaceBar(
      title: const Text('Kidney Health',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      background: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF44A8A0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(right: -30, top: -20,
            child: Container(width: 150, height: 150,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle))),
          Positioned(left: -20, bottom: 20,
            child: Container(width: 100, height: 100,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle))),
          const Positioned(right: 24, bottom: 40,
            child: Icon(Icons.water_drop, color: Colors.white, size: 80)),
          const Positioned(bottom: 56, left: 16,
            child: Text('Filter life. Stay balanced.',
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
              Icon(f['icon'] as IconData, color: const Color(0xFF4ECDC4), size: 22),
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

  Widget _buildKidneyStages() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.science_outlined, color: Color(0xFF4ECDC4)),
            SizedBox(width: 8),
            Text('CKD Stages (GFR)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
          ]),
          const SizedBox(height: 14),
          ..._stageData.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 70,
                  child: Text(s['stage'] as String,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(s['color'] as int))),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: s['pct'] as double,
                          backgroundColor: const Color(0xFFF0F0F0),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(s['color'] as int)),
                          minHeight: 7,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(s['desc'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    ),
  );

  Widget _buildHydrationTracker() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF80DEEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.water, color: Color(0xFF4ECDC4)),
            SizedBox(width: 8),
            Text('Daily Hydration Goal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
          ]),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(8, (i) => _waterGlass(i < 5)),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('5/8 glasses today  •  Keep going! 💧',
              style: TextStyle(color: Color(0xFF006064), fontWeight: FontWeight.w600, fontSize: 13))),
          const SizedBox(height: 8),
          const Text(
            '💡  Your kidneys need ~2L of water daily to function optimally.',
            style: TextStyle(color: Color(0xFF00838F), fontSize: 12),
          ),
        ],
      ),
    ),
  );

  Widget _waterGlass(bool filled) => Icon(
    filled ? Icons.water_drop : Icons.water_drop_outlined,
    color: filled ? const Color(0xFF4ECDC4) : const Color(0xFF80CBC4),
    size: 30,
  );

  Widget _buildTips() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kidney Care Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
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
                decoration: const BoxDecoration(color: Color(0xFFE0F7FA), shape: BoxShape.circle),
                child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: Color(0xFF4ECDC4), fontWeight: FontWeight.bold, fontSize: 13))),
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
            .where((m) => m.category.toLowerCase().contains('kidney'))
            .toList();

        final related = medProvider.medicines
            .where((m) => m.category == 'Diabetes' || m.category == 'Heart')
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
              Text('${all.length} product(s) for kidney health', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
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
        border: inCart ? Border.all(color: const Color(0xFF4ECDC4), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.medication, color: Color(0xFF4ECDC4), size: 26),
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
                Text('₹${med.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF4ECDC4))),
              ],
            ),
          ),
          if (inCart)
            Row(children: [
              _qBtn(Icons.remove, () => cart.removeMedicine(med.id), Colors.red),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              _qBtn(Icons.add, () => cart.updateQuantity(med.id, qty + 1), const Color(0xFF4ECDC4)),
            ])
          else
            GestureDetector(
              onTap: () {
                cart.addMedicine(med);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${med.name} added to cart'),
                  backgroundColor: const Color(0xFF4ECDC4),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFF4ECDC4), borderRadius: BorderRadius.circular(8)),
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
