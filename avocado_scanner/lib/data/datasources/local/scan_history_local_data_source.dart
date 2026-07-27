/// lib/data/datasources/local/scan_history_local_data_source.dart
///
/// Datasource yang bertanggung jawab untuk operasi CRUD ke tabel scan_history di SQLite.
library;

import 'package:sqflite/sqflite.dart';

import '../../../../app/errors/exceptions.dart';
import '../../database/database_service.dart';
import '../../database/db_schema.dart';
import '../../models/scan_result_model.dart';

abstract class ScanHistoryLocalDataSource {
  Future<List<ScanResultModel>> getScanHistory();
  Future<ScanResultModel> getScanResultById(int id);
  Future<int> saveScanResult(ScanResultModel result);
  Future<int> deleteScanResult(int id);
  Future<int> clearAllHistory();
}

class ScanHistoryLocalDataSourceImpl implements ScanHistoryLocalDataSource {

  ScanHistoryLocalDataSourceImpl({required this.databaseService});
  final DatabaseService databaseService;

  @override
  Future<int> clearAllHistory() async {
    try {
      final db = await databaseService.database;
      final count = await db.delete(DbSchema.tableScanHistory);
      return count;
    } catch (e) {
      throw AppDatabaseException('Gagal menghapus semua riwayat: ${e.toString()}');
    }
  }

  @override
  Future<int> deleteScanResult(int id) async {
    try {
      final db = await databaseService.database;
      final count = await db.delete(
        DbSchema.tableScanHistory,
        where: '${DbSchema.colId} = ?',
        whereArgs: [id],
      );
      return count;
    } catch (e) {
      throw AppDatabaseException('Gagal menghapus riwayat id $id: ${e.toString()}');
    }
  }

  @override
  Future<List<ScanResultModel>> getScanHistory() async {
    try {
      final db = await databaseService.database;
      final maps = await db.query(
        DbSchema.tableScanHistory,
        orderBy: '${DbSchema.colScanDate} DESC',
      );
      return List.generate(maps.length, (i) => ScanResultModel.fromMap(maps[i]));
    } catch (e) {
      throw AppDatabaseException('Gagal mengambil riwayat scan: ${e.toString()}');
    }
  }

  @override
  Future<ScanResultModel> getScanResultById(int id) async {
    try {
      final db = await databaseService.database;
      final maps = await db.query(
        DbSchema.tableScanHistory,
        where: '${DbSchema.colId} = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return ScanResultModel.fromMap(maps.first);
      } else {
        throw AppDatabaseException('Riwayat dengan id $id tidak ditemukan.');
      }
    } catch (e) {
      throw AppDatabaseException('Gagal mengambil riwayat id $id: ${e.toString()}');
    }
  }

  @override
  Future<int> saveScanResult(ScanResultModel result) async {
    try {
      final db = await databaseService.database;
      final map = result.toMap();
      // Hapus ID jika ada, karena akan di-autoincrement
      map.remove(DbSchema.colId);

      final id = await db.insert(
        DbSchema.tableScanHistory,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      throw AppDatabaseException('Gagal menyimpan riwayat: ${e.toString()}');
    }
  }
}
