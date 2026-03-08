import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_local_datasource.dart';
import '../datasources/image_remote_datasource.dart';
import '../models/image_model.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource remoteDataSource;
  final ImageLocalDataSource localDataSource;

  ImageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ImageEntity>> uploadImage(File file) async {
    try {
      // Validate file exists
      if (!await file.exists()) {
        return const Left(ValidationFailure('File does not exist'));
      }

      // Validate file type
      final extension = file.path.split('.').last.toLowerCase();
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
      if (!allowedExtensions.contains(extension)) {
        return const Left(ValidationFailure('Invalid file type. Allowed: jpg, jpeg, png, gif, webp'));
      }

      // Validate file size (max 10MB)
      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) {
        return const Left(ValidationFailure('File size exceeds 10MB limit'));
      }

      // Save locally first
      final localFile = await localDataSource.saveImageLocally(file);

      // Upload to server
      final imageModel = await remoteDataSource.uploadImage(file);

      // Create model with local path
      final cachedModel = ImageModel(
        id: imageModel.id,
        url: imageModel.url,
        localPath: localFile.path,
        fileName: imageModel.fileName,
        uploadedAt: imageModel.uploadedAt,
        userId: imageModel.userId,
      );

      // Cache the uploaded image
      await localDataSource.cacheImage(cachedModel);

      return Right(cachedModel);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ImageEntity>>> getImages() async {
    try {
      // Try to get from remote
      final images = await remoteDataSource.getImages();

      // Cache the images
      await localDataSource.cacheImages(images);

      return Right(images);
    } on Exception catch (e) {
      // Fallback to cached images
      try {
        final cachedImages = await localDataSource.getCachedImages();
        if (cachedImages.isNotEmpty) {
          return Right(cachedImages);
        }
        return Left(ServerFailure(e.toString()));
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ImageEntity>> getImageById(String id) async {
    try {
      // Check cache first
      final cachedImage = await localDataSource.getCachedImageById(id);
      if (cachedImage != null) {
        return Right(cachedImage);
      }

      // Fetch from remote
      final image = await remoteDataSource.getImageById(id);

      // Cache the image
      await localDataSource.cacheImage(image);

      return Right(image);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(String id) async {
    try {
      // Delete from server
      await remoteDataSource.deleteImage(id);

      // Remove from local cache
      await localDataSource.removeImage(id);

      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
