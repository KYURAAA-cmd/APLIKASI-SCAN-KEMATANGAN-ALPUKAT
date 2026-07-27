/// lib/domain/repositories/scan_history_repository.dart
///
/// Kontrak abstrak untuk repository yang mengelola riwayat scan.
/// Berada di layer domain, tidak memiliki dependensi ke framework atau data layer.
library;

import 'package:dartz/dartz.dart';
import '../../app/errors/failures.dart';
import '../entities/scan_result.dart';

abstract class ScanHistoryRepository {
  /// Mengambil semua riwayat scan dari data source.
  /// Mengembalikan List<ScanResult> jika berhasil, atau Failure jika gagal.
  Future<Either<Failure, List<ScanResult>>> getScanHistory();

  /// Mengambil riwayat scan berdasarkan ID.
  Future<Either<Failure, ScanResult>> getScanResultById(int id);

  /// Menyimpan hasil scan baru.
  /// Mengembalikan ID dari item yang baru disimpan jika berhasil.
  Future<Either<Failure, int>> saveScanResult(ScanResult result);

  /// Menghapus riwayat scan berdasarkan ID.
  /// Mengembalikan jumlah baris yang dihapus.
  Future<Either<Failure, int>> deleteScanResult(int id);

  /// Menghapus semua riwayat scan.
  /// Mengembalikan jumlah baris yang dihapus.
  Future<Either<Failure, int>> clearAllHistory();
}