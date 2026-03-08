import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/medicine/domain/entities/medicine_entity.dart';
import '../../features/medicine/presentation/pages/add_edit_medicine_page.dart';
import '../../features/medicine/presentation/providers/medicine_provider.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});
  @override
  State<PharmacyScreen> createState() => _PharmacyState();
}

class _PharmacyState extends State<PharmacyScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        context.read<MedicineProvider>().loadMedicines());
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Consumer<MedicineProvider>(
      builder: (context, provider, _) {
        final cats = ['All', ...provider.categories];
        final medicines = _selectedCategory == 'All'
            ? provider.displayList
            : provider.displayList.where((m) => m.category == _selectedCategory).toList();
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.white, elevation: 0,
            title: const Text('Pharmacy', style: TextStyle(color: Color(0xFF1E293B), fontSize: 20, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
                  ),
                  if (cart.itemCount > 0)
                    Positioned(right: 6, top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(cart.itemCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF2196F3)),
                tooltip: 'Add Medicine',
                onPressed: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditMedicinePage()));
                  if (result == true) provider.loadMedicines();
                },
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF2196F3)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (q) { provider.search(q); setState(() {}); },
                        decoration: InputDecoration(
                          hintText: 'Search medicines...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchCtrl.clear(); provider.clearSearch(); setState(() {}); })
                              : null,
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    if (!provider.isSearching)
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: cats.length,
                          itemBuilder: (_, i) {
                            final cat = cats[i];
                            final sel = _selectedCategory == cat;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategory = cat),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: sel ? const Color(0xFF2196F3) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: sel ? const Color(0xFF2196F3) : const Color(0xFFE2E8F0)),
                                ),
                                child: Text(cat, style: TextStyle(color: sel ? Colors.white : const Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 13)),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: medicines.isEmpty
                          ? const Center(child: Text('No medicines found', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16)))
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: medicines.length,
                              itemBuilder: (_, i) => _medicineCard(context, medicines[i], cart, provider),
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _medicineCard(BuildContext context, MedicineEntity med, CartProvider cart, MedicineProvider provider) {
    final inCart = cart.isInCart(med.id);
    final qty = cart.quantityOf(med.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: inCart ? Border.all(color: const Color(0xFF2196F3), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.medication, color: Color(0xFF2196F3), size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(med.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E293B)))),
                  if (!med.inStock) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Out of Stock', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))),
                ]),
                const SizedBox(height: 2),
                Text(med.category, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                Text(med.dosage, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\u20b9' + med.price.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2196F3))),
                    Row(children: [
                      _editBtn(context, med, provider),
                      const SizedBox(width: 6),
                      _deleteBtn(context, med, provider),
                      const SizedBox(width: 6),
                      if (med.inStock)
                        inCart
                            ? Row(children: [
                                _qtyBtn(Icons.remove, () => cart.removeMedicine(med.id), Colors.red),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(qty.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                _qtyBtn(Icons.add, () => cart.addMedicine(med), const Color(0xFF2196F3)),
                              ])
                            : GestureDetector(
                                onTap: () { cart.addMedicine(med); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(med.name + ' added'), backgroundColor: const Color(0xFF4CAF50), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1))); },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(8)),
                                  child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add, color: Colors.white, size: 16), SizedBox(width: 4), Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))]))),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, Color color) => GestureDetector(
    onTap: onTap,
    child: Container(padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: color)),
  );

  Widget _editBtn(BuildContext ctx, MedicineEntity med, MedicineProvider provider) => GestureDetector(
    onTap: () async {
      final result = await Navigator.push(ctx, MaterialPageRoute(builder: (_) => AddEditMedicinePage(medicine: med)));
      if (result == true) provider.loadMedicines();
    },
    child: Container(padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.edit, size: 16, color: Colors.orange)),
  );

  Widget _deleteBtn(BuildContext ctx, MedicineEntity med, MedicineProvider provider) => GestureDetector(
    onTap: () => _confirmDelete(ctx, med, provider),
    child: Container(padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.delete_outline, size: 16, color: Colors.red)),
  );

  void _confirmDelete(BuildContext ctx, MedicineEntity med, MedicineProvider provider) {
    showDialog(context: ctx, builder: (c) => AlertDialog(
      title: const Text('Delete Medicine'),
      content: Text('Remove ' + med.name + ' from inventory?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
        TextButton(onPressed: () { Navigator.pop(c); provider.deleteMedicine(med.id); },
            child: const Text('Delete', style: TextStyle(color: Colors.red))),
      ],
    ));
  }
}
