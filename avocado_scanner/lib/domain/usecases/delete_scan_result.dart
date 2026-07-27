/// lib/domain/usecases/delete_scan_result.dart
///
/// Use case untuk menghapus sebuah riwayat scan berdasarkan ID.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../app/errors/failures.dart';
import '../repositories/scan_history_repository.dart';
import 'usecase.dart';

class DeleteScanResult implements UseCase<int, DeleteScanResultParams> {

  DeleteScanResult(this.repository);
  final ScanHistoryRepository repository;

  @override
  Future<Either<Failure, int>> call(DeleteScanResultParams params) async => repository.deleteScanResult(params.id);
}

class DeleteScanResultParams extends Equatable {

  const DeleteScanResultParams({required this.id});
  final int id;

  @override
  List<Object> get props => [id];
}