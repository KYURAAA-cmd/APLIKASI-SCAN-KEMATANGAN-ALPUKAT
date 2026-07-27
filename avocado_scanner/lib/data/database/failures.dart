/// lib/app/errors/failures.dart
///
/// Mendefinisikan class-class Failure untuk error handling menggunakan Either.
library;

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

/// Kegagalan yang berhubungan dengan database
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Kegagalan umum dari server/API (untuk masa depan)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Kegagalan yang berhubungan dengan cache
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}