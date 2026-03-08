import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nepmed/core/errors/failures.dart';
import 'package:nepmed/core/usecases/usecase.dart';
import 'package:nepmed/features/image/domain/entities/image_entity.dart';
import 'package:nepmed/features/image/domain/usecases/delete_image_usecase.dart';
import 'package:nepmed/features/image/domain/usecases/get_image_by_id_usecase.dart';
import 'package:nepmed/features/image/domain/usecases/get_images_usecase.dart';
import 'package:nepmed/features/image/domain/usecases/upload_image_usecase.dart';
import 'package:nepmed/features/image/presentation/providers/image_provider.dart';

class MockUploadImageUseCase extends Mock implements UploadImageUseCase {}

class MockGetImagesUseCase extends Mock implements GetImagesUseCase {}

class MockGetImageByIdUseCase extends Mock implements GetImageByIdUseCase {}

class MockDeleteImageUseCase extends Mock implements DeleteImageUseCase {}

class MockFile extends Mock implements File {}

void main() {
  late ImageStateProvider provider;
  late MockUploadImageUseCase mockUploadImageUseCase;
  late MockGetImagesUseCase mockGetImagesUseCase;
  late MockGetImageByIdUseCase mockGetImageByIdUseCase;
  late MockDeleteImageUseCase mockDeleteImageUseCase;
  late MockFile mockFile;

  setUp(() {
    mockUploadImageUseCase = MockUploadImageUseCase();
    mockGetImagesUseCase = MockGetImagesUseCase();
    mockGetImageByIdUseCase = MockGetImageByIdUseCase();
    mockDeleteImageUseCase = MockDeleteImageUseCase();

    provider = ImageStateProvider(
      uploadImageUseCase: mockUploadImageUseCase,
      getImagesUseCase: mockGetImagesUseCase,
      getImageByIdUseCase: mockGetImageByIdUseCase,
      deleteImageUseCase: mockDeleteImageUseCase,
    );

    mockFile = MockFile();
  });

  setUpAll(() {
    registerFallbackValue(UploadImageParams(file: MockFile()));
    registerFallbackValue(NoParams());
    registerFallbackValue(const GetImageByIdParams(id: ''));
    registerFallbackValue(const DeleteImageParams(id: ''));
  });

  final tImageEntity = ImageEntity(
    id: '1',
    url: 'https://example.com/image.jpg',
    fileName: 'image.jpg',
    uploadedAt: DateTime(2024, 1, 1),
  );

  final tImageList = [
    tImageEntity,
    ImageEntity(
      id: '2',
      url: 'https://example.com/image2.jpg',
      fileName: 'image2.jpg',
      uploadedAt: DateTime(2024, 1, 2),
    ),
  ];

  group('ImageStateProvider', () {
    test('initial status should be initial', () {
      expect(provider.status, ImageStatus.initial);
      expect(provider.images, isEmpty);
      expect(provider.selectedImage, isNull);
      expect(provider.errorMessage, isNull);
    });

    group('uploadImage', () {
      test('should emit uploading then success status on successful upload', () async {
        // Arrange
        when(() => mockUploadImageUseCase(any()))
            .thenAnswer((_) async => Right(tImageEntity));

        // Act
        await provider.uploadImage(mockFile);

        // Assert
        expect(provider.status, ImageStatus.success);
        expect(provider.images, contains(tImageEntity));
        expect(provider.selectedImage, tImageEntity);
        expect(provider.errorMessage, isNull);
      });

      test('should emit error status on failed upload', () async {
        // Arrange
        when(() => mockUploadImageUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Upload failed')));

        // Act
        await provider.uploadImage(mockFile);

        // Assert
        expect(provider.status, ImageStatus.error);
        expect(provider.errorMessage, 'Upload failed');
      });
    });

    group('getImages', () {
      test('should emit success with images on successful fetch', () async {
        // Arrange
        when(() => mockGetImagesUseCase(any()))
            .thenAnswer((_) async => Right(tImageList));

        // Act
        await provider.getImages();

        // Assert
        expect(provider.status, ImageStatus.success);
        expect(provider.images, tImageList);
        expect(provider.errorMessage, isNull);
      });

      test('should emit error on failed fetch', () async {
        // Arrange
        when(() => mockGetImagesUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Network error')));

        // Act
        await provider.getImages();

        // Assert
        expect(provider.status, ImageStatus.error);
        expect(provider.errorMessage, 'Network error');
      });
    });

    group('deleteImage', () {
      test('should remove image from list on successful delete', () async {
        // Arrange
        when(() => mockGetImagesUseCase(any()))
            .thenAnswer((_) async => Right(tImageList));
        when(() => mockDeleteImageUseCase(any()))
            .thenAnswer((_) async => const Right(null));

        // First, load images
        await provider.getImages();
        expect(provider.images.length, 2);

        // Act
        await provider.deleteImage('1');

        // Assert
        expect(provider.status, ImageStatus.success);
        expect(provider.images.any((img) => img.id == '1'), isFalse);
      });
    });

    group('selectImage', () {
      test('should set selected image', () {
        // Act
        provider.selectImage(tImageEntity);

        // Assert
        expect(provider.selectedImage, tImageEntity);
      });
    });

    group('clearSelection', () {
      test('should clear selected image', () {
        // Arrange
        provider.selectImage(tImageEntity);

        // Act
        provider.clearSelection();

        // Assert
        expect(provider.selectedImage, isNull);
      });
    });

    group('clearError', () {
      test('should clear error message', () async {
        // Arrange
        when(() => mockUploadImageUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Error')));
        await provider.uploadImage(mockFile);
        expect(provider.errorMessage, isNotNull);

        // Act
        provider.clearError();

        // Assert
        expect(provider.errorMessage, isNull);
      });
    });
  });
}
