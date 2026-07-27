/// lib/app/errors/exceptions.dart
///
/// Mendefinisikan custom exceptions untuk ditangkap di data layer.
library;

class ServerException implements Exception {
  ServerException(this.message);
  final String message;
}

class AppDatabaseException implements Exception {
  AppDatabaseException(this.message);
  final String message;
}

class CacheException implements Exception {}
