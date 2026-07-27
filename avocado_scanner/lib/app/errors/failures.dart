abstract class Failure {
  const Failure(this.message);
  final String message;
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class MLFailure extends Failure {
  const MLFailure(super.message);
}

class CameraFailure extends Failure {
  const CameraFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String? message]) : super(message ?? 'Terjadi kesalahan yang tidak diketahui');
}
