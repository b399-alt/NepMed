import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GetImagesUseCase implements UseCase<List<ImageEntity>, NoParams> {
  final ImageRepository repository;

  GetImagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ImageEntity>>> call(NoParams params) {
    return repository.getImages();
  }
}
