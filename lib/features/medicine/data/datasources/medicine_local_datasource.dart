import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../models/medicine_model.dart';

abstract class MedicineLocalDataSource {
  Future<List<MedicineModel>> getMedicines();
  Future<MedicineModel> getMedicineById(String id);
  Future<List<MedicineModel>> searchMedicines(String query);
  Future<MedicineModel> addMedicine(MedicineModel medicine);
  Future<MedicineModel> updateMedicine(MedicineModel medicine);
  Future<void> deleteMedicine(String id);
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final Box<MedicineModel> medicineBox;
  final _uuid = const Uuid();

  MedicineLocalDataSourceImpl({required this.medicineBox}) {
    _seedDefaultMedicines();
  }

  void _seedDefaultMedicines() {
    if (medicineBox.isEmpty) {
      final defaults = [
        MedicineModel(
          id: _uuid.v4(),
          name: 'Paracetamol 500mg',
          category: 'Pain Relief',
          description: 'Effective pain relief and fever reducer. Suitable for headaches, body aches, and mild to moderate pain.',
          price: 50.0,
          dosage: '1-2 tablets every 4-6 hours',
          manufacturer: 'Generic Pharma',
          inStock: true,
          stockCount: 200,
        ),
        MedicineModel(
          id: _uuid.v4(),
          name: 'Vitamin D3 1000IU',
          category: 'Vitamins',
          description: 'Essential vitamin for bone health, immunity, and overall wellbeing. Supports calcium absorption.',
          price: 299.0,
          dosage: '1 tablet daily with meals',
          manufacturer: 'HealthCare Labs',
          inStock: true,
          stockCount: 150,
        ),
        MedicineModel(
          id: _uuid.v4(),
          name: 'Omeprazole 20mg',
          category: 'Digestive',
          description: 'Proton pump inhibitor for acidity, heartburn, and gastric ulcers. Provides 24-hour relief.',
          price: 120.0,
          dosage: '1 capsule before breakfast',
          manufacturer: 'GastroCare',
          inStock: true,
          stockCount: 100,
        ),
        MedicineModel(
          id: _uuid.v4(),
          name: 'Metformin 500mg',
          category: 'Diabetes',
          description: 'First-line medication for type 2 diabetes management. Helps control blood sugar levels.',
          price: 85.0,
          dosage: '1 tablet twice daily with meals',
          manufacturer: 'DiabeCare',
          inStock: true,
          stockCount: 180,
        ),
        MedicineModel(
          id: _uuid.v4(),
          name: 'Amlodipine 5mg',
          category: 'Heart',
          description: 'Calcium channel blocker for blood pressure control and angina. Keeps heart rate steady.',
          price: 95.0,
          dosage: '1 tablet once daily',
          manufacturer: 'CardioMed',
          inStock: true,
          stockCount: 120,
        ),
        MedicineModel(
          id: _uuid.v4(),
          name: 'Azithromycin 500mg',
          category: 'Antibiotics',
          description: 'Broad-spectrum antibiotic for respiratory, skin, and ear infections.',
          price: 565.0,
          dosage: '1 tablet daily for 3-5 days',
          manufacturer: 'AntiBio Labs',
          inStock: true,
          stockCount: 80,
        ),
        MedicineModel(
          id: _uuid.v4(),
          name: 'Cetirizine 10mg',
          category: 'Allergy',
          description: 'Non-drowsy antihistamine for allergic rhinitis, hay fever, and skin allergies.',
          price: 45.0,
          dosage: '1 tablet daily',
          manufacturer: 'AllerCare',
          inStock: true,
          stockCount: 250,
        ),
        MedicineModel(
          id: _uuid.v4(),
          name: 'Atorvastatin 20mg',
          category: 'Heart',
          description: 'Statin medication for lowering cholesterol and reducing cardiovascular risk.',
          price: 185.0,
          dosage: '1 tablet at bedtime',
          manufacturer: 'CardioMed',
          inStock: true,
          stockCount: 90,
        ),
      ];
      for (final m in defaults) {
        medicineBox.put(m.id, m);
      }
    }
  }

  @override
  Future<List<MedicineModel>> getMedicines() async =>
      medicineBox.values.toList();

  @override
  Future<MedicineModel> getMedicineById(String id) async {
    final medicine = medicineBox.get(id);
    if (medicine == null) throw const CacheFailure('Medicine not found');
    return medicine;
  }

  @override
  Future<List<MedicineModel>> searchMedicines(String query) async {
    final q = query.toLowerCase();
    return medicineBox.values
        .where((m) =>
            m.name.toLowerCase().contains(q) ||
            m.category.toLowerCase().contains(q) ||
            m.description.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<MedicineModel> addMedicine(MedicineModel medicine) async {
    await medicineBox.put(medicine.id, medicine);
    return medicine;
  }

  @override
  Future<MedicineModel> updateMedicine(MedicineModel medicine) async {
    await medicineBox.put(medicine.id, medicine);
    return medicine;
  }

  @override
  Future<void> deleteMedicine(String id) async {
    await medicineBox.delete(id);
  }
}
