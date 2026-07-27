/// lib/domain/usecases/clear_all_history.dart
///
/// Use case untuk menghapus semua data riwayat scan.
library;

import 'package:dartz/dartz.dart';
import '../../app/errors/failures.dart';
import '../repositories/scan_history_repository.dart';
import 'usecase.dart';

class ClearAllHistory implements UseCase<int, NoParams> {

  ClearAllHistory(this.repository);
  final ScanHistoryRepository repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) async => repository.clearAllHistory();
}