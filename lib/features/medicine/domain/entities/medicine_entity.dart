import 'package:equatable/equatable.dart';

class MedicineEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String dosage;
  final String manufacturer;
  final bool inStock;
  final int stockCount;

  const MedicineEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.dosage,
    required this.manufacturer,
    this.inStock = true,
    this.stockCount = 100,
  });

  @override
  List<Object?> get props => [id, name, category, price];
}
