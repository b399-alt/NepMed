import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nepmed/core/errors/failures.dart';
import 'package:nepmed/core/usecases/usecase.dart';
import 'package:nepmed/features/image/domain/entities/image_entity.dart';
import 'package:nepmed/features/image/domain/repositories/image_repository.dart';
import 'package:nepmed/features/image/domain/usecases/get_images_usecase.dart';

class MockImageRepository extends Mock implements ImageRepository {}

void main() {
  late GetImagesUseCase useCase;
  late MockImageRepository mockRepository;

  setUp(() {
    mockRepository = MockImageRepository();
    useCase = GetImagesUseCase(mockRepository);
  });

  final tImageList = [
    ImageEntity(
      id: '1',
      url: 'https://example.com/image1.jpg',
      fileName: 'image1.jpg',
      uploadedAt: DateTime(2024, 1, 1),
    ),
    ImageEntity(
      id: '2',
      url: 'https://example.com/image2.jpg',
      fileName: 'image2.jpg',
      uploadedAt: DateTime(2024, 1, 2),
    ),
  ];

  group('GetImagesUseCase', () {
    test('should return list of images on success', () async {
      // Arrange
      when(() => mockRepository.getImages())
          .thenAnswer((_) async => Right(tImageList));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(tImageList));
      verify(() => mockRepository.getImages()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no images exist', () async {
      // Arrange
      when(() => mockRepository.getImages())
          .thenAnswer((_) async => const Right(<ImageEntity>[]));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Right(<ImageEntity>[]));
      verify(() => mockRepository.getImages()).called(1);
    });

    test('should return ServerFailure when fetch fails', () async {
      // Arrange
      const failure = ServerFailure('Network error');
      when(() => mockRepository.getImages())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getImages()).called(1);
    });
  });
}
