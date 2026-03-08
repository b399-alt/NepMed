import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nepmed/features/image/presentation/widgets/server_image.dart';

void main() {
  group('ServerImage Widget', () {
    testWidgets('should display CachedNetworkImage with correct URL', (tester) async {
      // Arrange
      const testUrl = 'https://example.com/test.jpg';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServerImage(
              imageUrl: testUrl,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.imageUrl, equals(testUrl));
    });

    testWidgets('should apply width and height when provided', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServerImage(
              imageUrl: 'https://example.com/test.jpg',
              width: 200,
              height: 150,
            ),
          ),
        ),
      );

      // Assert
      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.width, equals(200));
      expect(cachedImage.height, equals(150));
    });

    testWidgets('should apply border radius with ClipRRect', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ServerImage(
              imageUrl: 'https://example.com/test.jpg',
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ClipRRect), findsOneWidget);
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, equals(BorderRadius.circular(16)));
    });

    testWidgets('should use BoxFit.cover by default', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServerImage(
              imageUrl: 'https://example.com/test.jpg',
            ),
          ),
        ),
      );

      // Assert
      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.fit, equals(BoxFit.cover));
    });

    testWidgets('should apply custom BoxFit when provided', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServerImage(
              imageUrl: 'https://example.com/test.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

      // Assert
      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.fit, equals(BoxFit.contain));
    });
  });

  group('ServerImageCircular Widget', () {
    testWidgets('should create circular image with ClipOval', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServerImageCircular(
              imageUrl: 'https://example.com/avatar.jpg',
              radius: 50,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('should set correct dimensions based on radius', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServerImageCircular(
              imageUrl: 'https://example.com/avatar.jpg',
              radius: 30,
            ),
          ),
        ),
      );

      // Assert
      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(cachedImage.width, equals(60)); // radius * 2
      expect(cachedImage.height, equals(60)); // radius * 2
    });
  });
}
