/// lib/domain/usecases/get_scan_history.dart
///
/// Use case untuk mendapatkan daftar semua riwayat scan.
library;

import 'package:dartz/dartz.dart';
import '../../app/errors/failures.dart';
import '../entities/scan_result.dart';
import '../repositories/scan_history_repository.dart';
import 'usecase.dart';

class GetScanHistory implements UseCase<List<ScanResult>, NoParams> {

  GetScanHistory(this.repository);
  final ScanHistoryRepository repository;

  @override
  Future<Either<Failure, List<ScanResult>>> call(NoParams params) async => repository.getScanHistory();
}