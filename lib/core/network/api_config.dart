class ApiConfig {
  // Base URL for the API server
  // Change this to your actual server URL
  static const String baseUrl = 'https://api.example.com';

  // Image endpoints
  static const String imagesEndpoint = '/images';
  static const String uploadEndpoint = '/images/upload';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Max file size (10MB)
  static const int maxFileSize = 10 * 1024 * 1024;

  // Allowed image extensions
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
}
