import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/subscription_repository.dart';

class CancelSubscriptionUseCase implements UseCase<void, SubIdParams> {
  final SubscriptionRepository repository;
  CancelSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubIdParams params) =>
      repository.cancelSubscription(params.id);
}

class PauseSubscriptionUseCase implements UseCase<void, SubIdParams> {
  final SubscriptionRepository repository;
  PauseSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubIdParams params) =>
      repository.pauseSubscription(params.id);
}

class ResumeSubscriptionUseCase implements UseCase<void, SubIdParams> {
  final SubscriptionRepository repository;
  ResumeSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubIdParams params) =>
      repository.resumeSubscription(params.id);
}

class SubIdParams extends Equatable {
  final String id;
  const SubIdParams(this.id);
  @override
  List<Object?> get props => [id];
}
