import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nepmed/core/errors/failures.dart';
import 'package:nepmed/features/image/domain/entities/image_entity.dart';
import 'package:nepmed/features/image/domain/repositories/image_repository.dart';
import 'package:nepmed/features/image/domain/usecases/upload_image_usecase.dart';

class MockImageRepository extends Mock implements ImageRepository {}

class MockFile extends Mock implements File {}

void main() {
  late UploadImageUseCase useCase;
  late MockImageRepository mockRepository;
  late MockFile mockFile;

  setUpAll(() {
    mockFile = MockFile();
    registerFallbackValue(mockFile);
  });

  setUp(() {
    mockRepository = MockImageRepository();
    useCase = UploadImageUseCase(mockRepository);
    mockFile = MockFile();
  });

  final tImageEntity = ImageEntity(
    id: '1',
    url: 'https://example.com/image.jpg',
    fileName: 'image.jpg',
    uploadedAt: DateTime(2024, 1, 1),
    userId: 'user1',
  );

  group('UploadImageUseCase', () {
    test('should upload image and return ImageEntity on success', () async {
      // Arrange
      when(() => mockRepository.uploadImage(any()))
          .thenAnswer((_) async => Right(tImageEntity));

      // Act
      final result = await useCase(UploadImageParams(file: mockFile));

      // Assert
      expect(result, Right(tImageEntity));
      verify(() => mockRepository.uploadImage(mockFile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when upload fails', () async {
      // Arrange
      const failure = ServerFailure('Upload failed');
      when(() => mockRepository.uploadImage(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(UploadImageParams(file: mockFile));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.uploadImage(mockFile)).called(1);
    });

    test('should return ValidationFailure for invalid file', () async {
      // Arrange
      const failure = ValidationFailure('Invalid file type');
      when(() => mockRepository.uploadImage(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(UploadImageParams(file: mockFile));

      // Assert
      expect(result, const Left(failure));
    });
  });
}
