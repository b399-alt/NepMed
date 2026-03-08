import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions(String userId);
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionById(String id);
  Future<Either<Failure, SubscriptionEntity>> createSubscription(SubscriptionEntity subscription);
  Future<Either<Failure, SubscriptionEntity>> updateSubscription(SubscriptionEntity subscription);
  Future<Either<Failure, void>> cancelSubscription(String id);
  Future<Either<Failure, void>> pauseSubscription(String id);
  Future<Either<Failure, void>> resumeSubscription(String id);
}
