import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_local_datasource.dart';
import '../models/subscription_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDataSource localDataSource;
  SubscriptionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions(String userId) async {
    try {
      final models = await localDataSource.getSubscriptions(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionById(String id) async {
    try {
      final model = await localDataSource.getSubscriptionById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> createSubscription(SubscriptionEntity subscription) async {
    try {
      final model = SubscriptionModel.fromEntity(subscription);
      final result = await localDataSource.createSubscription(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> updateSubscription(SubscriptionEntity subscription) async {
    try {
      final model = SubscriptionModel.fromEntity(subscription);
      final result = await localDataSource.updateSubscription(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription(String id) async {
    try {
      await localDataSource.updateStatus(id, SubscriptionStatus.cancelled.index);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pauseSubscription(String id) async {
    try {
      await localDataSource.updateStatus(id, SubscriptionStatus.paused.index);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resumeSubscription(String id) async {
    try {
      await localDataSource.updateStatus(id, SubscriptionStatus.active.index);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
