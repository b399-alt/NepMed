import '../../domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({
    required super.id,
    required super.url,
    super.localPath,
    super.fileName,
    required super.uploadedAt,
    super.userId,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as String,
      url: json['url'] as String,
      localPath: json['localPath'] as String?,
      fileName: json['fileName'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'localPath': localPath,
      'fileName': fileName,
      'uploadedAt': uploadedAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory ImageModel.fromEntity(ImageEntity entity) {
    return ImageModel(
      id: entity.id,
      url: entity.url,
      localPath: entity.localPath,
      fileName: entity.fileName,
      uploadedAt: entity.uploadedAt,
      userId: entity.userId,
    );
  }
}
