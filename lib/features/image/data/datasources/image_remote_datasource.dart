import 'dart:io';
import 'package:dio/dio.dart';
import '../models/image_model.dart';

abstract class ImageRemoteDataSource {
  Future<ImageModel> uploadImage(File file);
  Future<List<ImageModel>> getImages();
  Future<ImageModel> getImageById(String id);
  Future<void> deleteImage(String id);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  ImageRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<ImageModel> uploadImage(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        '$baseUrl/images/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ImageModel.fromJson(response.data);
      } else {
        throw Exception('Failed to upload image: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  @override
  Future<List<ImageModel>> getImages() async {
    try {
      final response = await dio.get('$baseUrl/images');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ImageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch images: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Fetch failed: $e');
    }
  }

  @override
  Future<ImageModel> getImageById(String id) async {
    try {
      final response = await dio.get('$baseUrl/images/$id');

      if (response.statusCode == 200) {
        return ImageModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch image: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Fetch failed: $e');
    }
  }

  @override
  Future<void> deleteImage(String id) async {
    try {
      final response = await dio.delete('$baseUrl/images/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete image: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }
}
