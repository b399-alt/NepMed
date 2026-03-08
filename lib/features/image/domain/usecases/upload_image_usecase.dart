import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class UploadImageUseCase implements UseCase<ImageEntity, UploadImageParams> {
  final ImageRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<Either<Failure, ImageEntity>> call(UploadImageParams params) {
    return repository.uploadImage(params.file);
  }
}

class UploadImageParams extends Equatable {
  final File file;

  const UploadImageParams({required this.file});

  @override
  List<Object> get props => [file];
}
