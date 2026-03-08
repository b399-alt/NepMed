import 'package:flutter_test/flutter_test.dart';
import 'package:nepmed/features/image/domain/entities/image_entity.dart';

void main() {
  final tDateTime = DateTime(2024, 1, 15, 10, 30);

  group('ImageEntity', () {
    test('should create ImageEntity with required fields', () {
      // Act
      final entity = ImageEntity(
        id: '123',
        url: 'https://example.com/image.jpg',
        uploadedAt: tDateTime,
      );

      // Assert
      expect(entity.id, equals('123'));
      expect(entity.url, equals('https://example.com/image.jpg'));
      expect(entity.uploadedAt, equals(tDateTime));
      expect(entity.localPath, isNull);
      expect(entity.fileName, isNull);
      expect(entity.userId, isNull);
    });

    test('should create ImageEntity with all fields', () {
      // Act
      final entity = ImageEntity(
        id: '123',
        url: 'https://example.com/image.jpg',
        localPath: '/local/path/image.jpg',
        fileName: 'image.jpg',
        uploadedAt: tDateTime,
        userId: 'user_456',
      );

      // Assert
      expect(entity.id, equals('123'));
      expect(entity.url, equals('https://example.com/image.jpg'));
      expect(entity.localPath, equals('/local/path/image.jpg'));
      expect(entity.fileName, equals('image.jpg'));
      expect(entity.uploadedAt, equals(tDateTime));
      expect(entity.userId, equals('user_456'));
    });

    test('two ImageEntities with same props should be equal', () {
      // Arrange
      final entity1 = ImageEntity(
        id: '123',
        url: 'https://example.com/image.jpg',
        uploadedAt: tDateTime,
      );

      final entity2 = ImageEntity(
        id: '123',
        url: 'https://example.com/image.jpg',
        uploadedAt: tDateTime,
      );

      // Assert
      expect(entity1, equals(entity2));
    });

    test('two ImageEntities with different props should not be equal', () {
      // Arrange
      final entity1 = ImageEntity(
        id: '123',
        url: 'https://example.com/image1.jpg',
        uploadedAt: tDateTime,
      );

      final entity2 = ImageEntity(
        id: '456',
        url: 'https://example.com/image2.jpg',
        uploadedAt: tDateTime,
      );

      // Assert
      expect(entity1, isNot(equals(entity2)));
    });

    test('props should return correct list of properties', () {
      // Arrange
      final entity = ImageEntity(
        id: '123',
        url: 'https://example.com/image.jpg',
        localPath: '/local/path',
        fileName: 'image.jpg',
        uploadedAt: tDateTime,
        userId: 'user_456',
      );

      // Act
      final props = entity.props;

      // Assert
      expect(props, contains('123'));
      expect(props, contains('https://example.com/image.jpg'));
      expect(props, contains('/local/path'));
      expect(props, contains('image.jpg'));
      expect(props, contains(tDateTime));
      expect(props, contains('user_456'));
    });
  });
}
