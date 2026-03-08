import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptionsUseCase implements UseCase<List<SubscriptionEntity>, UserIdParams> {
  final SubscriptionRepository repository;
  GetSubscriptionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> call(UserIdParams params) =>
      repository.getSubscriptions(params.userId);
}

class UserIdParams extends Equatable {
  final String userId;
  const UserIdParams(this.userId);
  @override
  List<Object?> get props => [userId];
}
