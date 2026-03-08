import 'package:hive/hive.dart';
import '../../../../core/errors/failures.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionLocalDataSource {
  Future<List<SubscriptionModel>> getSubscriptions(String userId);
  Future<SubscriptionModel> getSubscriptionById(String id);
  Future<SubscriptionModel> createSubscription(SubscriptionModel model);
  Future<SubscriptionModel> updateSubscription(SubscriptionModel model);
  Future<void> updateStatus(String id, int statusIndex);
}

class SubscriptionLocalDataSourceImpl implements SubscriptionLocalDataSource {
  final Box<SubscriptionModel> subscriptionBox;
  SubscriptionLocalDataSourceImpl({required this.subscriptionBox});

  @override
  Future<List<SubscriptionModel>> getSubscriptions(String userId) async =>
      subscriptionBox.values.where((s) => s.userId == userId).toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));

  @override
  Future<SubscriptionModel> getSubscriptionById(String id) async {
    final model = subscriptionBox.get(id);
    if (model == null) throw const CacheFailure('Subscription not found');
    return model;
  }

  @override
  Future<SubscriptionModel> createSubscription(SubscriptionModel model) async {
    await subscriptionBox.put(model.id, model);
    return model;
  }

  @override
  Future<SubscriptionModel> updateSubscription(SubscriptionModel model) async {
    await subscriptionBox.put(model.id, model);
    return model;
  }

  @override
  Future<void> updateStatus(String id, int statusIndex) async {
    final existing = subscriptionBox.get(id);
    if (existing == null) throw const CacheFailure('Subscription not found');
    await subscriptionBox.put(id, existing.copyWithStatus(statusIndex));
  }
}
