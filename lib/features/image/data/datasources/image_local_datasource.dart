import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/image_model.dart';

abstract class ImageLocalDataSource {
  Future<void> cacheImage(ImageModel image);
  Future<void> cacheImages(List<ImageModel> images);
  Future<List<ImageModel>> getCachedImages();
  Future<ImageModel?> getCachedImageById(String id);
  Future<void> removeImage(String id);
  Future<void> clearCache();
  Future<File> saveImageLocally(File file);
}

class ImageLocalDataSourceImpl implements ImageLocalDataSource {
  static const String _cacheKey = 'cached_images';
  final Map<String, ImageModel> _imageCache = {};

  @override
  Future<void> cacheImage(ImageModel image) async {
    _imageCache[image.id] = image;
  }

  @override
  Future<void> cacheImages(List<ImageModel> images) async {
    for (final image in images) {
      _imageCache[image.id] = image;
    }
  }

  @override
  Future<List<ImageModel>> getCachedImages() async {
    return _imageCache.values.toList();
  }

  @override
  Future<ImageModel?> getCachedImageById(String id) async {
    return _imageCache[id];
  }

  @override
  Future<void> removeImage(String id) async {
    final image = _imageCache[id];
    if (image != null && image.localPath != null) {
      final file = File(image.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    _imageCache.remove(id);
  }

  @override
  Future<void> clearCache() async {
    for (final image in _imageCache.values) {
      if (image.localPath != null) {
        final file = File(image.localPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    _imageCache.clear();
  }

  @override
  Future<File> saveImageLocally(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = file.path.split('/').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final localPath = '${directory.path}/images/${timestamp}_$fileName';

    final imageDir = Directory('${directory.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    return await file.copy(localPath);
  }
}
