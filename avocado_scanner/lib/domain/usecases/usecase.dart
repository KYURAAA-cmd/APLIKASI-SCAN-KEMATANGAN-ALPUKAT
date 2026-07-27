/// lib/domain/usecases/usecase.dart
///
/// Base class abstrak untuk semua use case di dalam aplikasi.
/// Ini memastikan konsistensi dan mengikuti prinsip SOLID.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../app/errors/failures.dart';

/// [Type] adalah tipe data yang dikembalikan jika berhasil.
/// [Params] adalah parameter yang dibutuhkan untuk menjalankan use case.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Kelas helper untuk use case yang tidak memerlukan parameter.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}