import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class UpdateSubscriptionUseCase implements UseCase<SubscriptionEntity, UpdateSubscriptionParams> {
  final SubscriptionRepository repository;
  UpdateSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, SubscriptionEntity>> call(UpdateSubscriptionParams params) =>
      repository.updateSubscription(params.subscription);
}

class UpdateSubscriptionParams extends Equatable {
  final SubscriptionEntity subscription;
  const UpdateSubscriptionParams(this.subscription);
  @override
  List<Object?> get props => [subscription];
}
