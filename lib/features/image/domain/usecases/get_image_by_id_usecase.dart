import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GetImageByIdUseCase implements UseCase<ImageEntity, GetImageByIdParams> {
  final ImageRepository repository;

  GetImageByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ImageEntity>> call(GetImageByIdParams params) {
    return repository.getImageById(params.id);
  }
}

class GetImageByIdParams extends Equatable {
  final String id;

  const GetImageByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
