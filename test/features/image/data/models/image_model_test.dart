import 'package:flutter_test/flutter_test.dart';
import 'package:nepmed/features/image/data/models/image_model.dart';
import 'package:nepmed/features/image/domain/entities/image_entity.dart';

void main() {
  final tDateTime = DateTime(2024, 1, 15, 10, 30);

  final tImageModel = ImageModel(
    id: '123',
    url: 'https://example.com/images/test.jpg',
    localPath: '/local/path/test.jpg',
    fileName: 'test.jpg',
    uploadedAt: tDateTime,
    userId: 'user_456',
  );

  final tJson = {
    'id': '123',
    'url': 'https://example.com/images/test.jpg',
    'localPath': '/local/path/test.jpg',
    'fileName': 'test.jpg',
    'uploadedAt': '2024-01-15T10:30:00.000',
    'userId': 'user_456',
  };

  group('ImageModel', () {
    test('should be a subclass of ImageEntity', () {
      // Assert
      expect(tImageModel, isA<ImageEntity>());
    });

    test('fromJson should return a valid model', () {
      // Act
      final result = ImageModel.fromJson(tJson);

      // Assert
      expect(result.id, equals('123'));
      expect(result.url, equals('https://example.com/images/test.jpg'));
      expect(result.localPath, equals('/local/path/test.jpg'));
      expect(result.fileName, equals('test.jpg'));
      expect(result.userId, equals('user_456'));
    });

    test('toJson should return a valid JSON map', () {
      // Act
      final result = tImageModel.toJson();

      // Assert
      expect(result['id'], equals('123'));
      expect(result['url'], equals('https://example.com/images/test.jpg'));
      expect(result['localPath'], equals('/local/path/test.jpg'));
      expect(result['fileName'], equals('test.jpg'));
      expect(result['userId'], equals('user_456'));
    });

    test('fromEntity should create ImageModel from ImageEntity', () {
      // Arrange
      final entity = ImageEntity(
        id: 'entity_id',
        url: 'https://example.com/entity.jpg',
        fileName: 'entity.jpg',
        uploadedAt: tDateTime,
      );

      // Act
      final result = ImageModel.fromEntity(entity);

      // Assert
      expect(result.id, equals('entity_id'));
      expect(result.url, equals('https://example.com/entity.jpg'));
      expect(result.fileName, equals('entity.jpg'));
      expect(result, isA<ImageModel>());
    });

    test('should handle null optional fields in fromJson', () {
      // Arrange
      final jsonWithNulls = {
        'id': '123',
        'url': 'https://example.com/test.jpg',
        'localPath': null,
        'fileName': null,
        'uploadedAt': '2024-01-15T10:30:00.000',
        'userId': null,
      };

      // Act
      final result = ImageModel.fromJson(jsonWithNulls);

      // Assert
      expect(result.localPath, isNull);
      expect(result.fileName, isNull);
      expect(result.userId, isNull);
    });
  });
}
