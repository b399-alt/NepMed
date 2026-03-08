import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:nepmed/features/image/domain/entities/image_entity.dart';
import 'package:nepmed/features/image/presentation/pages/image_detail_page.dart';
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
  late ImageStateProvider imageProvider;

  final tDateTime = DateTime(2024, 3, 15, 14, 30);

  final tImage = ImageEntity(
    id: 'test_id_123',
    url: 'https://example.com/test_image.jpg',
    fileName: 'test_image.jpg',
    uploadedAt: tDateTime,
    userId: 'user_456',
  );

  setUp(() {
    imageProvider = ImageStateProvider(
      uploadImageUseCase: MockUploadImageUseCase(),
      getImagesUseCase: MockGetImagesUseCase(),
      getImageByIdUseCase: MockGetImageByIdUseCase(),
      deleteImageUseCase: MockDeleteImageUseCase(),
    );
  });

  Widget createTestWidget(ImageEntity image) {
    return MaterialApp(
      home: ChangeNotifierProvider<ImageStateProvider>.value(
        value: imageProvider,
        child: ImageDetailPage(image: image),
      ),
    );
  }

  group('ImageDetailPage Widget', () {
    testWidgets('should display app bar with file name as title', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));

      // Assert
      expect(find.text('test_image.jpg'), findsWidgets);
    });

    testWidgets('should display delete button in app bar', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));

      // Assert
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('should display image info panel with file name', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));

      // Assert - the label format is "label: " in _InfoRow widget
      expect(find.text('File Name: '), findsOneWidget);
      expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
    });

    testWidgets('should display upload date info', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));

      // Assert
      expect(find.text('Uploaded: '), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.text('15/3/2024 14:30'), findsOneWidget);
    });

    testWidgets('should display URL info', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));

      // Assert
      expect(find.text('URL: '), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets('should show delete confirmation dialog when delete is tapped', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.text('Delete Image'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this image?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should display cancel and delete buttons in dialog', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - verify dialog buttons are present
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should display InteractiveViewer for image zoom', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(tImage));

      // Assert
      expect(find.byType(InteractiveViewer), findsOneWidget);
    });

    testWidgets('should handle image without fileName gracefully', (tester) async {
      // Arrange
      final imageWithoutFileName = ImageEntity(
        id: 'test_id',
        url: 'https://example.com/image.jpg',
        uploadedAt: tDateTime,
      );

      // Act
      await tester.pumpWidget(createTestWidget(imageWithoutFileName));

      // Assert - should show 'Image Details' as fallback title
      expect(find.text('Image Details'), findsOneWidget);
    });
  });
}
