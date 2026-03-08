import 'package:hive/hive.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/subscription_entity.dart';

class SubscriptionModel {
  final String id;
  final String userId;
  final List<Map<dynamic, dynamic>> itemMaps;
  final int frequencyIndex;
  final int intervalDays;
  final DateTime startDate;
  final DateTime nextDelivery;
  final String deliveryAddress;
  final String deliveryPhone;
  final int statusIndex;
  final double totalPrice;
  final int discountPercent;
  final String? notes;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.itemMaps,
    required this.frequencyIndex,
    required this.intervalDays,
    required this.startDate,
    required this.nextDelivery,
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.statusIndex,
    required this.totalPrice,
    required this.discountPercent,
    this.notes,
  });

  factory SubscriptionModel.fromEntity(SubscriptionEntity e) => SubscriptionModel(
        id: e.id,
        userId: e.userId,
        itemMaps: e.items.map((i) => i.toMap()).toList(),
        frequencyIndex: e.frequency.index,
        intervalDays: e.intervalDays,
        startDate: e.startDate,
        nextDelivery: e.nextDelivery,
        deliveryAddress: e.deliveryAddress,
        deliveryPhone: e.deliveryPhone,
        statusIndex: e.status.index,
        totalPrice: e.totalPrice,
        discountPercent: e.discountPercent,
        notes: e.notes,
      );

  SubscriptionEntity toEntity() => SubscriptionEntity(
        id: id,
        userId: userId,
        items: itemMaps.map((m) => CartItemEntity.fromMap(m)).toList(),
        frequency: SubscriptionFrequency.values[frequencyIndex],
        intervalDays: intervalDays,
        startDate: startDate,
        nextDelivery: nextDelivery,
        deliveryAddress: deliveryAddress,
        deliveryPhone: deliveryPhone,
        status: SubscriptionStatus.values[statusIndex],
        totalPrice: totalPrice,
        discountPercent: discountPercent,
        notes: notes,
      );

  SubscriptionModel copyWithStatus(int statusIdx) => SubscriptionModel(
        id: id,
        userId: userId,
        itemMaps: itemMaps,
        frequencyIndex: frequencyIndex,
        intervalDays: intervalDays,
        startDate: startDate,
        nextDelivery: nextDelivery,
        deliveryAddress: deliveryAddress,
        deliveryPhone: deliveryPhone,
        statusIndex: statusIdx,
        totalPrice: totalPrice,
        discountPercent: discountPercent,
        notes: notes,
      );
}

class SubscriptionModelAdapter extends TypeAdapter<SubscriptionModel> {
  @override
  final int typeId = 2;

  @override
  SubscriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      itemMaps: (fields[2] as List).cast<Map<dynamic, dynamic>>(),
      frequencyIndex: fields[3] as int,
      intervalDays: fields[4] as int,
      startDate: fields[5] as DateTime,
      nextDelivery: fields[6] as DateTime,
      deliveryAddress: fields[7] as String,
      deliveryPhone: fields[8] as String,
      statusIndex: fields[9] as int,
      totalPrice: (fields[10] as num).toDouble(),
      discountPercent: fields[11] as int,
      notes: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.itemMaps)
      ..writeByte(3)
      ..write(obj.frequencyIndex)
      ..writeByte(4)
      ..write(obj.intervalDays)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.nextDelivery)
      ..writeByte(7)
      ..write(obj.deliveryAddress)
      ..writeByte(8)
      ..write(obj.deliveryPhone)
      ..writeByte(9)
      ..write(obj.statusIndex)
      ..writeByte(10)
      ..write(obj.totalPrice)
      ..writeByte(11)
      ..write(obj.discountPercent)
      ..writeByte(12)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
