/// lib/presentation/providers/history_provider.dart
///
/// Provider untuk mengelola state dan logika bisnis terkait riwayat scan.
library;

import 'package:flutter/material.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/usecases/clear_all_history.dart';
import '../../domain/usecases/delete_scan_result.dart';
import '../../domain/usecases/get_scan_history.dart';
import '../../domain/usecases/save_scan_result.dart';
import '../../domain/usecases/usecase.dart';
import 'view_state.dart';

class HistoryProvider extends ChangeNotifier {

  HistoryProvider({
    required GetScanHistory getScanHistory,
    required SaveScanResult saveScanResult,
    required DeleteScanResult deleteScanResult,
    required ClearAllHistory clearAllHistory,
  })  : _getScanHistory = getScanHistory,
        _saveScanResult = saveScanResult,
        _deleteScanResult = deleteScanResult,
        _clearAllHistory = clearAllHistory;
  // Use Cases
  final GetScanHistory _getScanHistory;
  final SaveScanResult _saveScanResult;
  final DeleteScanResult _deleteScanResult;
  final ClearAllHistory _clearAllHistory;

  // Private state
  ViewState _state = ViewState.idle;
  List<ScanResult> _history = [];
  String _errorMessage = '';

  // Public getters
  ViewState get state => _state;
  List<ScanResult> get history => _history;
  String get errorMessage => _errorMessage;

  /// Mengubah state dan memberi tahu listener.
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Mengambil semua data riwayat scan.
  Future<void> fetchHistory() async {
    _setState(ViewState.loading);
    final result = await _getScanHistory(NoParams());
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setState(ViewState.error);
      },
      (historyData) {
        _history = historyData;
        _setState(ViewState.success);
      },
    );
  }

  /// Menyimpan satu item riwayat.
  /// Mengembalikan true jika berhasil, false jika gagal.
  Future<bool> saveHistoryItem(ScanResult result) async {
    final resultOrFailure = await _saveScanResult(SaveScanResultParams(result: result));

    return resultOrFailure.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false; // Indicate failure
      },
      (newId) {
        // Buat objek ScanResult baru dengan ID dari database
        final savedResult = result.copyWith(id: newId);
        // Tambahkan ke bagian atas daftar
        _history.insert(0, savedResult);
        notifyListeners();
        return true; // Indicate success
      },
    );
  }

  /// Menghapus satu item riwayat berdasarkan ID.
  Future<void> deleteHistoryItem(int id) async {
    final result = await _deleteScanResult(DeleteScanResultParams(id: id));
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (deletedCount) {
        if (deletedCount > 0) {
          _history.removeWhere((item) => item.id == id);
          notifyListeners();
        }
      },
    );
  }

  /// Menghapus semua riwayat.
  Future<void> clearHistory() async {
    final result = await _clearAllHistory(NoParams());
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (deletedCount) {
        if (deletedCount > 0) {
          _history.clear();
          notifyListeners();
        }
      },
    );
  }
}