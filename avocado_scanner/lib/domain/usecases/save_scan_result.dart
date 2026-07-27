/// lib/domain/usecases/save_scan_result.dart
///
/// Use case untuk menyimpan sebuah hasil scan.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../app/errors/failures.dart';
import '../entities/scan_result.dart';
import '../repositories/scan_history_repository.dart';
import 'usecase.dart';

class SaveScanResult implements UseCase<int, SaveScanResultParams> {

  SaveScanResult(this.repository);
  final ScanHistoryRepository repository;

  @override
  Future<Either<Failure, int>> call(SaveScanResultParams params) async => repository.saveScanResult(params.result);
}

class SaveScanResultParams extends Equatable {

  const SaveScanResultParams({required this.result});
  final ScanResult result;

  @override
  List<Object> get props => [result];
}