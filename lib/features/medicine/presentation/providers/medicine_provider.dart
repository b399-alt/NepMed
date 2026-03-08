import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/medicine_entity.dart';
import '../../domain/usecases/add_medicine_usecase.dart';
import '../../domain/usecases/delete_medicine_usecase.dart';
import '../../domain/usecases/get_medicines_usecase.dart';
import '../../domain/usecases/search_medicines_usecase.dart';
import '../../domain/usecases/update_medicine_usecase.dart';

enum MedicineStatus { initial, loading, loaded, error }

class MedicineProvider extends ChangeNotifier {
  final GetMedicinesUseCase getMedicinesUseCase;
  final AddMedicineUseCase addMedicineUseCase;
  final UpdateMedicineUseCase updateMedicineUseCase;
  final DeleteMedicineUseCase deleteMedicineUseCase;
  final SearchMedicinesUseCase searchMedicinesUseCase;

  MedicineProvider({
    required this.getMedicinesUseCase,
    required this.addMedicineUseCase,
    required this.updateMedicineUseCase,
    required this.deleteMedicineUseCase,
    required this.searchMedicinesUseCase,
  });

  MedicineStatus _status = MedicineStatus.initial;
  List<MedicineEntity> _medicines = [];
  List<MedicineEntity> _searchResults = [];
  String? _errorMessage;
  bool _isSearching = false;

  MedicineStatus get status => _status;
  List<MedicineEntity> get medicines => _medicines;
  List<MedicineEntity> get searchResults => _searchResults;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == MedicineStatus.loading;
  bool get isSearching => _isSearching;
  List<MedicineEntity> get displayList => _isSearching ? _searchResults : _medicines;

  Future<void> loadMedicines() async {
    _status = MedicineStatus.loading;
    notifyListeners();

    final result = await getMedicinesUseCase(NoParams());
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = MedicineStatus.error;
      },
      (medicines) {
        _medicines = medicines;
        _status = MedicineStatus.loaded;
      },
    );
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    final result = await searchMedicinesUseCase(SearchParams(query));
    result.fold(
      (failure) => _searchResults = [],
      (results) => _searchResults = results,
    );
    notifyListeners();
  }

  void clearSearch() {
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }

  Future<bool> addMedicine({
    required String name,
    required String category,
    required String description,
    required double price,
    required String dosage,
    required String manufacturer,
    int stockCount = 100,
  }) async {
    final medicine = MedicineEntity(
      id: const Uuid().v4(),
      name: name,
      category: category,
      description: description,
      price: price,
      dosage: dosage,
      manufacturer: manufacturer,
      inStock: stockCount > 0,
      stockCount: stockCount,
    );
    final result = await addMedicineUseCase(AddMedicineParams(medicine));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (added) {
        _medicines.add(added);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> updateMedicine(MedicineEntity medicine) async {
    final result = await updateMedicineUseCase(UpdateMedicineParams(medicine));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (updated) {
        final index = _medicines.indexWhere((m) => m.id == updated.id);
        if (index != -1) _medicines[index] = updated;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> deleteMedicine(String id) async {
    final result = await deleteMedicineUseCase(DeleteMedicineParams(id));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _medicines.removeWhere((m) => m.id == id);
        notifyListeners();
        return true;
      },
    );
  }

  List<MedicineEntity> getMedicinesByCategory(String category) =>
      _medicines.where((m) => m.category == category).toList();

  List<String> get categories =>
      _medicines.map((m) => m.category).toSet().toList()..sort();
}
