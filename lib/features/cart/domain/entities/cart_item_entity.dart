import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CartItemEntity extends Equatable {
  final String medicineId;
  final String medicineName;
  final String category;
  final double unitPrice;
  // ignore: must_be_immutable
  int quantity;

  CartItemEntity({
    required this.medicineId,
    required this.medicineName,
    required this.category,
    required this.unitPrice,
    this.quantity = 1,
  });

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toMap() => {
    'medicineId': medicineId,
    'medicineName': medicineName,
    'category': category,
    'unitPrice': unitPrice,
    'quantity': quantity,
  };

  factory CartItemEntity.fromMap(Map<dynamic, dynamic> map) => CartItemEntity(
    medicineId: map['medicineId'] as String,
    medicineName: map['medicineName'] as String,
    category: map['category'] as String,
    unitPrice: (map['unitPrice'] as num).toDouble(),
    quantity: map['quantity'] as int? ?? 1,
  );

  CartItemEntity copyWith({int? quantity}) => CartItemEntity(
    medicineId: medicineId,
    medicineName: medicineName,
    category: category,
    unitPrice: unitPrice,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [medicineId];
}
