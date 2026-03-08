import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/usecases/cancel_subscription_usecase.dart';
import '../../domain/usecases/create_subscription_usecase.dart';
import '../../domain/usecases/get_subscriptions_usecase.dart';
import '../../domain/usecases/update_subscription_usecase.dart';

enum SubscriptionLoadStatus { initial, loading, loaded, error }

class SubscriptionProvider extends ChangeNotifier {
  final GetSubscriptionsUseCase getSubscriptionsUseCase;
  final CreateSubscriptionUseCase createSubscriptionUseCase;
  final UpdateSubscriptionUseCase updateSubscriptionUseCase;
  final CancelSubscriptionUseCase cancelSubscriptionUseCase;
  final PauseSubscriptionUseCase pauseSubscriptionUseCase;
  final ResumeSubscriptionUseCase resumeSubscriptionUseCase;

  SubscriptionProvider({
    required this.getSubscriptionsUseCase,
    required this.createSubscriptionUseCase,
    required this.updateSubscriptionUseCase,
    required this.cancelSubscriptionUseCase,
    required this.pauseSubscriptionUseCase,
    required this.resumeSubscriptionUseCase,
  });

  SubscriptionLoadStatus _status = SubscriptionLoadStatus.initial;
  List<SubscriptionEntity> _subscriptions = [];
  String? _errorMessage;

  SubscriptionLoadStatus get status => _status;
  List<SubscriptionEntity> get subscriptions => _subscriptions;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == SubscriptionLoadStatus.loading;

  List<SubscriptionEntity> get activeSubscriptions =>
      _subscriptions.where((s) => s.status == SubscriptionStatus.active).toList();

  List<SubscriptionEntity> get pausedSubscriptions =>
      _subscriptions.where((s) => s.status == SubscriptionStatus.paused).toList();

  List<SubscriptionEntity> get cancelledSubscriptions =>
      _subscriptions.where((s) => s.status == SubscriptionStatus.cancelled).toList();

  Future<void> loadSubscriptions(String userId) async {
    _status = SubscriptionLoadStatus.loading;
    notifyListeners();

    final result = await getSubscriptionsUseCase(UserIdParams(userId));
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _status = SubscriptionLoadStatus.error;
      },
      (subs) {
        _subscriptions = subs;
        _status = SubscriptionLoadStatus.loaded;
      },
    );
    notifyListeners();
  }

  Future<bool> createSubscription({
    required String userId,
    required List<CartItemEntity> items,
    required SubscriptionFrequency frequency,
    required int intervalDays,
    required String deliveryAddress,
    required String deliveryPhone,
    required int discountPercent,
    String? notes,
  }) async {
    final totalPrice = items.fold<double>(0, (sum, i) => sum + i.totalPrice);
    final now = DateTime.now();
    final subscription = SubscriptionEntity(
      id: const Uuid().v4(),
      userId: userId,
      items: items,
      frequency: frequency,
      intervalDays: intervalDays,
      startDate: now,
      nextDelivery: now.add(Duration(days: intervalDays)),
      deliveryAddress: deliveryAddress,
      deliveryPhone: deliveryPhone,
      status: SubscriptionStatus.active,
      totalPrice: totalPrice,
      discountPercent: discountPercent,
      notes: notes,
    );

    final result = await createSubscriptionUseCase(CreateSubscriptionParams(subscription));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (created) {
        _subscriptions.insert(0, created);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> updateSubscription(SubscriptionEntity subscription) async {
    final result = await updateSubscriptionUseCase(UpdateSubscriptionParams(subscription));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (updated) {
        final index = _subscriptions.indexWhere((s) => s.id == updated.id);
        if (index != -1) _subscriptions[index] = updated;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> cancelSubscription(String id) async {
    final result = await cancelSubscriptionUseCase(SubIdParams(id));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _updateLocalStatus(id, SubscriptionStatus.cancelled);
        return true;
      },
    );
  }

  Future<bool> pauseSubscription(String id) async {
    final result = await pauseSubscriptionUseCase(SubIdParams(id));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _updateLocalStatus(id, SubscriptionStatus.paused);
        return true;
      },
    );
  }

  Future<bool> resumeSubscription(String id) async {
    final result = await resumeSubscriptionUseCase(SubIdParams(id));
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _updateLocalStatus(id, SubscriptionStatus.active);
        return true;
      },
    );
  }

  void _updateLocalStatus(String id, SubscriptionStatus newStatus) {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index != -1) {
      final s = _subscriptions[index];
      _subscriptions[index] = SubscriptionEntity(
        id: s.id,
        userId: s.userId,
        items: s.items,
        frequency: s.frequency,
        intervalDays: s.intervalDays,
        startDate: s.startDate,
        nextDelivery: s.nextDelivery,
        deliveryAddress: s.deliveryAddress,
        deliveryPhone: s.deliveryPhone,
        status: newStatus,
        totalPrice: s.totalPrice,
        discountPercent: s.discountPercent,
        notes: s.notes,
      );
    }
    notifyListeners();
  }
}
