import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:nepmed/features/image/presentation/pages/image_upload_page.dart';
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

  setUp(() {
    imageProvider = ImageStateProvider(
      uploadImageUseCase: MockUploadImageUseCase(),
      getImagesUseCase: MockGetImagesUseCase(),
      getImageByIdUseCase: MockGetImageByIdUseCase(),
      deleteImageUseCase: MockDeleteImageUseCase(),
    );
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<ImageStateProvider>.value(
        value: imageProvider,
        child: const ImageUploadPage(),
      ),
    );
  }

  group('ImageUploadPage Widget', () {
    testWidgets('should display app bar with correct title', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Upload Image'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display image placeholder when no image selected', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.add_photo_alternate), findsOneWidget);
      expect(find.text('Tap to select an image'), findsOneWidget);
    });

    testWidgets('should display Select Image button', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Select Image'), findsOneWidget);
      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('should display Upload button', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - just verify the button and icon are present
      expect(find.text('Upload'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_upload), findsOneWidget);
    });

    testWidgets('should show bottom sheet when tapping image area', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Find the GestureDetector containing the placeholder
      await tester.tap(find.byIcon(Icons.add_photo_alternate));
      await tester.pumpAndSettle();

      // Assert - modal bottom sheet should be shown
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
    });
  });
}
