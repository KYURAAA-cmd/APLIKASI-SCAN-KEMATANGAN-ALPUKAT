/// lib/presentation/providers/view_state.dart
///
/// Enum untuk merepresentasikan state dari sebuah view atau provider.
library;

enum ViewState {
  /// State awal, tidak ada operasi yang sedang berjalan.
  idle,

  /// Sedang memuat data.
  loading,

  /// Data berhasil dimuat.
  success,

  /// Terjadi kesalahan saat memuat data.
  error,
}