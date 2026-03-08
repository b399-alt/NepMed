import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart';
import 'package:nepmed/core/usecases/usecase.dart';
import 'package:nepmed/features/image/domain/entities/image_entity.dart';
import 'package:nepmed/features/image/presentation/pages/image_gallery_page.dart';
import 'package:nepmed/features/image/presentation/providers/image_provider.dart';
import 'package:nepmed/features/image/domain/usecases/delete_image_usecase.dart';
import 'package:nepmed/features/image/domain/usecases/get_image_by_id_usecase.dart';
import 'package:nepmed/features/image/domain/usecases/get_images_usecase.dart';
import 'package:nepmed/features/image/domain/usecases/upload_image_usecase.dart';

class MockUploadImageUseCase extends Mock implements UploadImageUseCase {}

class MockGetImagesUseCase extends Mock implements GetImagesUseCase {}

class MockGetImageByIdUseCase extends Mock implements GetImageByIdUseCase {}

class MockDeleteImageUseCase extends Mock implements DeleteImageUseCase {}

void main() {
  late MockUploadImageUseCase mockUploadImageUseCase;
  late MockGetImagesUseCase mockGetImagesUseCase;
  late MockGetImageByIdUseCase mockGetImageByIdUseCase;
  late MockDeleteImageUseCase mockDeleteImageUseCase;

  setUp(() {
    mockUploadImageUseCase = MockUploadImageUseCase();
    mockGetImagesUseCase = MockGetImagesUseCase();
    mockGetImageByIdUseCase = MockGetImageByIdUseCase();
    mockDeleteImageUseCase = MockDeleteImageUseCase();
  });

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  Widget createTestWidget(ImageStateProvider provider) {
    return MaterialApp(
      home: ChangeNotifierProvider<ImageStateProvider>.value(
        value: provider,
        child: const ImageGalleryPage(),
      ),
    );
  }

  group('ImageGalleryPage Widget', () {
    testWidgets('should display app bar with title and refresh button', (tester) async {
      // Arrange
      when(() => mockGetImagesUseCase(any()))
          .thenAnswer((_) async => const Right(<ImageEntity>[]));

      final provider = ImageStateProvider(
        uploadImageUseCase: mockUploadImageUseCase,
        getImagesUseCase: mockGetImagesUseCase,
        getImageByIdUseCase: mockGetImageByIdUseCase,
        deleteImageUseCase: mockDeleteImageUseCase,
      );

      // Act
      await tester.pumpWidget(createTestWidget(provider));
      await tester.pump();

      // Assert
      expect(find.text('Image Gallery'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display empty state when no images', (tester) async {
      // Arrange
      when(() => mockGetImagesUseCase(any()))
          .thenAnswer((_) async => const Right(<ImageEntity>[]));

      final provider = ImageStateProvider(
        uploadImageUseCase: mockUploadImageUseCase,
        getImagesUseCase: mockGetImagesUseCase,
        getImageByIdUseCase: mockGetImageByIdUseCase,
        deleteImageUseCase: mockDeleteImageUseCase,
      );

      // Act
      await tester.pumpWidget(createTestWidget(provider));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No images yet'), findsOneWidget);
      expect(find.text('Upload your first image to get started'), findsOneWidget);
      expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
    });

    testWidgets('should display floating action button', (tester) async {
      // Arrange
      when(() => mockGetImagesUseCase(any()))
          .thenAnswer((_) async => const Right(<ImageEntity>[]));

      final provider = ImageStateProvider(
        uploadImageUseCase: mockUploadImageUseCase,
        getImagesUseCase: mockGetImagesUseCase,
        getImageByIdUseCase: mockGetImageByIdUseCase,
        deleteImageUseCase: mockDeleteImageUseCase,
      );

      // Act
      await tester.pumpWidget(createTestWidget(provider));
      await tester.pump();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add_photo_alternate), findsNWidgets(2)); // FAB and empty state button
    });

    testWidgets('should display loading indicator when loading', (tester) async {
      // Arrange - use a completer to control when the async operation completes
      when(() => mockGetImagesUseCase(any()))
          .thenAnswer((_) async => const Right(<ImageEntity>[]));

      final provider = ImageStateProvider(
        uploadImageUseCase: mockUploadImageUseCase,
        getImagesUseCase: mockGetImagesUseCase,
        getImageByIdUseCase: mockGetImageByIdUseCase,
        deleteImageUseCase: mockDeleteImageUseCase,
      );

      // Act
      await tester.pumpWidget(createTestWidget(provider));

      // Assert - the widget should render with FAB and title present
      expect(find.text('Image Gallery'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
