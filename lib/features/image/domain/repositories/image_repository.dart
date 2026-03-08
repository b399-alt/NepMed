import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/image_entity.dart';

abstract class ImageRepository {
  Future<Either<Failure, ImageEntity>> uploadImage(File file);
  Future<Either<Failure, List<ImageEntity>>> getImages();
  Future<Either<Failure, ImageEntity>> getImageById(String id);
  Future<Either<Failure, void>> deleteImage(String id);
}
