import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class CreateSubscriptionUseCase implements UseCase<SubscriptionEntity, CreateSubscriptionParams> {
  final SubscriptionRepository repository;
  CreateSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, SubscriptionEntity>> call(CreateSubscriptionParams params) =>
      repository.createSubscription(params.subscription);
}

class CreateSubscriptionParams extends Equatable {
  final SubscriptionEntity subscription;
  const CreateSubscriptionParams(this.subscription);
  @override
  List<Object?> get props => [subscription];
}
