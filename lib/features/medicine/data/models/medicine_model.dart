import 'package:hive/hive.dart';
import '../../domain/entities/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  const MedicineModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.price,
    required super.dosage,
    required super.manufacturer,
    super.inStock,
    super.stockCount,
  });

  factory MedicineModel.fromEntity(MedicineEntity e) => MedicineModel(
        id: e.id,
        name: e.name,
        category: e.category,
        description: e.description,
        price: e.price,
        dosage: e.dosage,
        manufacturer: e.manufacturer,
        inStock: e.inStock,
        stockCount: e.stockCount,
      );

  MedicineEntity toEntity() => MedicineEntity(
        id: id,
        name: name,
        category: category,
        description: description,
        price: price,
        dosage: dosage,
        manufacturer: manufacturer,
        inStock: inStock,
        stockCount: stockCount,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'dosage': dosage,
        'manufacturer': manufacturer,
        'inStock': inStock,
        'stockCount': stockCount,
      };

  factory MedicineModel.fromMap(Map<dynamic, dynamic> map) => MedicineModel(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        description: map['description'] as String,
        price: (map['price'] as num).toDouble(),
        dosage: map['dosage'] as String,
        manufacturer: map['manufacturer'] as String,
        inStock: map['inStock'] as bool? ?? true,
        stockCount: map['stockCount'] as int? ?? 100,
      );
}

class MedicineModelAdapter extends TypeAdapter<MedicineModel> {
  @override
  final int typeId = 1;

  @override
  MedicineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineModel(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      description: fields[3] as String,
      price: (fields[4] as num).toDouble(),
      dosage: fields[5] as String,
      manufacturer: fields[6] as String,
      inStock: fields[7] as bool? ?? true,
      stockCount: fields[8] as int? ?? 100,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.dosage)
      ..writeByte(6)
      ..write(obj.manufacturer)
      ..writeByte(7)
      ..write(obj.inStock)
      ..writeByte(8)
      ..write(obj.stockCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
