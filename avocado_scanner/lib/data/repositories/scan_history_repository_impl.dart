/// lib/data/repositories/scan_history_repository_impl.dart
///
/// Implementasi konkret dari ScanHistoryRepository.
/// Menjembatani domain layer dengan data layer (datasource).
library;

import 'package:dartz/dartz.dart';
import '../../app/errors/exceptions.dart';
import '../../app/errors/failures.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_history_repository.dart';
import '../datasources/local/scan_history_local_data_source.dart';
import '../models/scan_result_model.dart';

class ScanHistoryRepositoryImpl implements ScanHistoryRepository {

  ScanHistoryRepositoryImpl({required this.localDataSource});
  final ScanHistoryLocalDataSource localDataSource;

  @override
  Future<Either<Failure, int>> clearAllHistory() async {
    try {
      final result = await localDataSource.clearAllHistory();
      return Right(result);
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> deleteScanResult(int id) async {
    try {
      final result = await localDataSource.deleteScanResult(id);
      return Right(result);
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ScanResult>>> getScanHistory() async {
    try {
      final resultModels = await localDataSource.getScanHistory();
      final results = resultModels.map((model) => model.toEntity()).toList();
      return Right(results);
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ScanResult>> getScanResultById(int id) async {
    try {
      final resultModel = await localDataSource.getScanResultById(id);
      return Right(resultModel.toEntity());
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> saveScanResult(ScanResult result) async {
    try {
      final resultModel = ScanResultModel.fromEntity(result);
      final newId = await localDataSource.saveScanResult(resultModel);
      return Right(newId);
    } on AppDatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}