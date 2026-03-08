import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/medicine_entity.dart';
import '../providers/medicine_provider.dart';

class AddEditMedicinePage extends StatefulWidget {
  final MedicineEntity? medicine;
  const AddEditMedicinePage({super.key, this.medicine});

  @override
  State<AddEditMedicinePage> createState() => _AddEditMedicinePageState();
}

class _AddEditMedicinePageState extends State<AddEditMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _dosageCtrl;
  late TextEditingController _manufacturerCtrl;
  late TextEditingController _stockCtrl;
  String _selectedCategory = 'Pain Relief';
  bool _inStock = true;

  final List<String> _categories = [
    'Pain Relief', 'Vitamins', 'Digestive', 'Diabetes', 'Heart',
    'Antibiotics', 'Allergy', 'Infection', 'Bone', 'Kidney', 'Eye', 'Lungs', 'Other'
  ];

  bool get _isEdit => widget.medicine != null;

  @override
  void initState() {
    super.initState();
    final m = widget.medicine;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _descCtrl = TextEditingController(text: m?.description ?? '');
    _priceCtrl = TextEditingController(text: m?.price.toString() ?? '');
    _dosageCtrl = TextEditingController(text: m?.dosage ?? '');
    _manufacturerCtrl = TextEditingController(text: m?.manufacturer ?? '');
    _stockCtrl = TextEditingController(text: m?.stockCount.toString() ?? '100');
    _selectedCategory = m?.category ?? 'Pain Relief';
    _inStock = m?.inStock ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _dosageCtrl.dispose();
    _manufacturerCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<MedicineProvider>();
    bool success;
    if (_isEdit) {
      final updated = MedicineEntity(
        id: widget.medicine!.id,
        name: _nameCtrl.text.trim(),
        category: _selectedCategory,
        description: _descCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),
        dosage: _dosageCtrl.text.trim(),
        manufacturer: _manufacturerCtrl.text.trim(),
        inStock: _inStock,
        stockCount: int.parse(_stockCtrl.text.trim()),
      );
      success = await provider.updateMedicine(updated);
    } else {
      success = await provider.addMedicine(
        name: _nameCtrl.text.trim(),
        category: _selectedCategory,
        description: _descCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),
        dosage: _dosageCtrl.text.trim(),
        manufacturer: _manufacturerCtrl.text.trim(),
        stockCount: int.parse(_stockCtrl.text.trim()),
      );
    }
    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Failed to save'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isEdit ? 'Edit Medicine' : 'Add Medicine',
          style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCard([
              _buildField(_nameCtrl, 'Medicine Name', Icons.medication, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _buildDropdown(),
              const SizedBox(height: 16),
              _buildField(_manufacturerCtrl, 'Manufacturer', Icons.business, validator: (v) => v!.isEmpty ? 'Required' : null),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              _buildField(_priceCtrl, 'Price (₹)', Icons.currency_rupee, keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter valid number';
                  return null;
                }),
              const SizedBox(height: 16),
              _buildField(_dosageCtrl, 'Dosage Instructions', Icons.info_outline, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              _buildField(_stockCtrl, 'Stock Count', Icons.inventory, keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Enter valid number';
                  return null;
                }),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('In Stock', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(_inStock ? 'Available for order' : 'Out of stock'),
                value: _inStock,
                activeColor: const Color(0xFF2196F3),
                onChanged: (v) => setState(() => _inStock = v),
              ),
            ]),
            const SizedBox(height: 16),
            _buildCard([
              _buildField(_descCtrl, 'Description', Icons.description,
                maxLines: 4, validator: (v) => v!.isEmpty ? 'Required' : null),
            ]),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(_isEdit ? 'Update Medicine' : 'Add Medicine',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _buildField(TextEditingController ctrl, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1, String? Function(String?)? validator}) =>
    TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2196F3)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
      ),
    );

  Widget _buildDropdown() => DropdownButtonFormField<String>(
    value: _selectedCategory,
    decoration: InputDecoration(
      labelText: 'Category',
      prefixIcon: const Icon(Icons.category, color: Color(0xFF2196F3)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
    ),
    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
    onChanged: (v) => setState(() => _selectedCategory = v!),
  );
}
