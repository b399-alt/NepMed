import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/image_repository.dart';

class DeleteImageUseCase implements UseCase<void, DeleteImageParams> {
  final ImageRepository repository;

  DeleteImageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteImageParams params) {
    return repository.deleteImage(params.id);
  }
}

class DeleteImageParams extends Equatable {
  final String id;

  const DeleteImageParams({required this.id});

  @override
  List<Object> get props => [id];
}
