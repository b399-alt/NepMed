import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/delete_image_usecase.dart';
import '../../domain/usecases/get_image_by_id_usecase.dart';
import '../../domain/usecases/get_images_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';

enum ImageStatus {
  initial,
  loading,
  uploading,
  success,
  error,
}

class ImageStateProvider extends ChangeNotifier {
  final UploadImageUseCase uploadImageUseCase;
  final GetImagesUseCase getImagesUseCase;
  final GetImageByIdUseCase getImageByIdUseCase;
  final DeleteImageUseCase deleteImageUseCase;

  ImageStateProvider({
    required this.uploadImageUseCase,
    required this.getImagesUseCase,
    required this.getImageByIdUseCase,
    required this.deleteImageUseCase,
  });

  ImageStatus _status = ImageStatus.initial;
  List<ImageEntity> _images = [];
  ImageEntity? _selectedImage;
  String? _errorMessage;
  double _uploadProgress = 0.0;

  ImageStatus get status => _status;
  List<ImageEntity> get images => _images;
  ImageEntity? get selectedImage => _selectedImage;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;

  Future<void> uploadImage(File file) async {
    _status = ImageStatus.uploading;
    _uploadProgress = 0.0;
    _errorMessage = null;
    notifyListeners();

    final result = await uploadImageUseCase(UploadImageParams(file: file));

    result.fold(
      (failure) {
        _status = ImageStatus.error;
        _errorMessage = failure.message;
      },
      (image) {
        _status = ImageStatus.success;
        _images.insert(0, image);
        _selectedImage = image;
        _uploadProgress = 1.0;
      },
    );

    notifyListeners();
  }

  Future<void> getImages() async {
    _status = ImageStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getImagesUseCase(NoParams());

    result.fold(
      (failure) {
        _status = ImageStatus.error;
        _errorMessage = failure.message;
      },
      (images) {
        _status = ImageStatus.success;
        _images = images;
      },
    );

    notifyListeners();
  }

  Future<void> getImageById(String id) async {
    _status = ImageStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getImageByIdUseCase(GetImageByIdParams(id: id));

    result.fold(
      (failure) {
        _status = ImageStatus.error;
        _errorMessage = failure.message;
      },
      (image) {
        _status = ImageStatus.success;
        _selectedImage = image;
      },
    );

    notifyListeners();
  }

  Future<void> deleteImage(String id) async {
    _status = ImageStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await deleteImageUseCase(DeleteImageParams(id: id));

    result.fold(
      (failure) {
        _status = ImageStatus.error;
        _errorMessage = failure.message;
      },
      (_) {
        _status = ImageStatus.success;
        _images.removeWhere((image) => image.id == id);
        if (_selectedImage?.id == id) {
          _selectedImage = null;
        }
      },
    );

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void selectImage(ImageEntity image) {
    _selectedImage = image;
    notifyListeners();
  }

  void clearSelection() {
    _selectedImage = null;
    notifyListeners();
  }
}
