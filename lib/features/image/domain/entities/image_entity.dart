import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String id;
  final String url;
  final String? localPath;
  final String? fileName;
  final DateTime uploadedAt;
  final String? userId;

  const ImageEntity({
    required this.id,
    required this.url,
    this.localPath,
    this.fileName,
    required this.uploadedAt,
    this.userId,
  });

  @override
  List<Object?> get props => [id, url, localPath, fileName, uploadedAt, userId];
}
