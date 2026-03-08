import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

enum SubscriptionFrequency { daily, weekly, biweekly, monthly, custom }

enum SubscriptionStatus { active, paused, cancelled }

extension SubscriptionFrequencyExt on SubscriptionFrequency {
  String get label {
    switch (this) {
      case SubscriptionFrequency.daily: return 'Daily';
      case SubscriptionFrequency.weekly: return 'Weekly';
      case SubscriptionFrequency.biweekly: return 'Every 2 Weeks';
      case SubscriptionFrequency.monthly: return 'Monthly';
      case SubscriptionFrequency.custom: return 'Custom';
    }
  }

  int get defaultDays {
    switch (this) {
      case SubscriptionFrequency.daily: return 1;
      case SubscriptionFrequency.weekly: return 7;
      case SubscriptionFrequency.biweekly: return 14;
      case SubscriptionFrequency.monthly: return 30;
      case SubscriptionFrequency.custom: return 1;
    }
  }

  int get discountPercent {
    switch (this) {
      case SubscriptionFrequency.daily: return 0;
      case SubscriptionFrequency.weekly: return 5;
      case SubscriptionFrequency.biweekly: return 10;
      case SubscriptionFrequency.monthly: return 15;
      case SubscriptionFrequency.custom: return 0;
    }
  }
}

extension SubscriptionStatusExt on SubscriptionStatus {
  String get label {
    switch (this) {
      case SubscriptionStatus.active: return 'Active';
      case SubscriptionStatus.paused: return 'Paused';
      case SubscriptionStatus.cancelled: return 'Cancelled';
    }
  }
}

class SubscriptionEntity extends Equatable {
  final String id;
  final String userId;
  final List<CartItemEntity> items;
  final SubscriptionFrequency frequency;
  final int intervalDays;
  final DateTime startDate;
  final DateTime nextDelivery;
  final String deliveryAddress;
  final String deliveryPhone;
  final SubscriptionStatus status;
  final double totalPrice;
  final int discountPercent;
  final String? notes;

  const SubscriptionEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.frequency,
    required this.intervalDays,
    required this.startDate,
    required this.nextDelivery,
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.status,
    required this.totalPrice,
    required this.discountPercent,
    this.notes,
  });

  double get discountedTotal => totalPrice * (1 - discountPercent / 100);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  String get medicineNames => items.map((i) => i.medicineName).join(', ');

  @override
  List<Object?> get props => [id];
}
