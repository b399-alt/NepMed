import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../../medicine/domain/entities/medicine_entity.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemEntity> _items = [];

  List<CartItemEntity> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;

  bool isInCart(String medicineId) => _items.any((i) => i.medicineId == medicineId);

  int quantityOf(String medicineId) {
    final item = _items.firstWhere((i) => i.medicineId == medicineId, orElse: () => CartItemEntity(medicineId: '', medicineName: '', category: '', unitPrice: 0));
    return item.medicineId.isEmpty ? 0 : item.quantity;
  }

  void addMedicine(MedicineEntity medicine) {
    final index = _items.indexWhere((i) => i.medicineId == medicine.id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      _items.add(CartItemEntity(
        medicineId: medicine.id,
        medicineName: medicine.name,
        category: medicine.category,
        unitPrice: medicine.price,
      ));
    }
    notifyListeners();
  }

  void removeMedicine(String medicineId) {
    final index = _items.indexWhere((i) => i.medicineId == medicineId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
      } else {
        _items.removeAt(index);
      }
    }
    notifyListeners();
  }

  void removeItem(String medicineId) {
    _items.removeWhere((i) => i.medicineId == medicineId);
    notifyListeners();
  }

  void updateQuantity(String medicineId, int quantity) {
    final index = _items.indexWhere((i) => i.medicineId == medicineId);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double discountedTotal(int discountPercent) {
    final discount = discountPercent / 100;
    return totalPrice * (1 - discount);
  }
}
