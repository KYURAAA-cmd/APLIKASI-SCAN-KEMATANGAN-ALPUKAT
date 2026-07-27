/// lib/app/constants/string_constants.dart
/// 
/// Konstanta string untuk UI dan localization
library;

class StringConstants {
  // Prevent instantiation
  StringConstants._();

  // App Strings
  static const String appName = 'Avocado Ripeness Scanner';
  static const String appTagline = 'Deteksi Tingkat Kematangan Alpukat dengan AI';

  // Screen Titles
  static const String homeTitle = 'Home';
  static const String cameraScanTitle = 'Scan Kamera';
  static const String galleryScanTitle = 'Scan dari Galeri';
  static const String historyTitle = 'Riwayat Scan';
  static const String settingsTitle = 'Pengaturan';
  static const String aboutTitle = 'Tentang';

  // Home Screen
  static const String welcomeMessage = 'Selamat datang di Avocado Ripeness Scanner';
  static const String scanNowButton = 'Mulai Scan';
  static const String scanCameraButton = 'Buka Kamera';
  static const String scanGalleryButton = 'Pilih dari Galeri';
  static const String viewHistoryButton = 'Lihat Riwayat';
  static const String settingsButton = 'Pengaturan';
  static const String aboutButton = 'Tentang Aplikasi';

  // Camera Screen
  static const String cameraScanningMessage = 'Arahkan kamera ke buah alpukat...';
  static const String cameraPermissionRequired = 'Izin kamera diperlukan';
  static const String captureButton = 'Ambil Foto';
  static const String switchCameraButton = 'Tukar Kamera';
  static const String toggleFlashButton = 'Lampu';

  // Gallery Screen
  static const String selectImageMessage = 'Pilih gambar alpukat dari galeri';
  static const String selectImageButton = 'Pilih Gambar';
  static const String noImageSelected = 'Tidak ada gambar yang dipilih';

  // Result Screen
  static const String resultTitle = 'Hasil Deteksi';
  static const String ripenesStatusTitle = 'Status Kematangan';
  static const String confidenceScoreTitle = 'Confidence Score';
  static const String recommendationTitle = 'Rekomendasi';
  static const String detectionDetailsTitle = 'Detail Deteksi';
  static const String saveResultButton = 'Simpan ke Riwayat';
  static const String shareResultButton = 'Bagikan';
  static const String scanAgainButton = 'Scan Lagi';
  static const String backButton = 'Kembali';

  // History Screen
  static const String noHistoryMessage = 'Belum ada riwayat scan';
  static const String deleteHistoryTitle = 'Hapus Riwayat';
  static const String deleteHistoryMessage = 'Yakin ingin menghapus item ini?';
  static const String clearAllHistoryTitle = 'Hapus Semua Riwayat';
  static const String clearAllHistoryMessage = 'Yakin ingin menghapus semua riwayat?';
  static const String yesButton = 'Ya';
  static const String noButton = 'Tidak';
  static const String cancelButton = 'Batal';
  static const String deleteButton = 'Hapus';
  static const String clearButton = 'Hapus Semua';

  // History Detail
  static const String detailedResultsTitle = 'Hasil Detail';
  static const String scanDateTimeTitle = 'Tanggal & Waktu';
  static const String imagePathTitle = 'Path Gambar';
  static const String inferenceTimeTitle = 'Waktu Inferensi';
  static const String fpsTitle = 'FPS';
  static const String detectionsTitle = 'Jumlah Deteksi';

  // Settings Screen
  static const String confidenceThresholdTitle = 'Confidence Threshold';
  static const String themeTitle = 'Tema';
  static const String languageTitle = 'Bahasa';
  static const String notificationsTitle = 'Notifikasi';
  static const String vibrationTitle = 'Getar';
  static const String soundTitle = 'Suara';
  static const String cameraQualityTitle = 'Kualitas Kamera';
  static const String autoSaveHistoryTitle = 'Simpan Riwayat Otomatis';
  static const String autoFocusTitle = 'Auto Focus';
  static const String maxHistoryItemsTitle = 'Maksimal Item Riwayat';
  static const String clearCacheTitle = 'Bersihkan Cache';
  static const String appInfoTitle = 'Informasi Aplikasi';

  // About Screen
  static const String aboutAppTitle = 'Tentang Aplikasi';
  static const String versionTitle = 'Versi';
  static const String builtWithTitle = 'Dibangun Dengan';
  static const String developedByTitle = 'Dikembangkan oleh';
  static const String technologiesTitle = 'Teknologi';
  static const String licenseTitle = 'Lisensi';
  static const String contactTitle = 'Hubungi';
  static const String privacyPolicyTitle = 'Kebijakan Privasi';
  static const String termsOfServiceTitle = 'Syarat & Ketentuan';

  // Ripeness Classes
  static const String ripenessUnripe = 'Mentah';
  static const String ripenessHalfRipe = 'Setengah Matang';
  static const String ripenessRipe = 'Matang';
  static const String ripenessRotten = 'Busuk';

  // Error Messages
  static const String errorCameraPermissionDenied = 'Izin kamera ditolak';
  static const String errorCameraNotAvailable = 'Kamera tidak tersedia';
  static const String errorModelLoadingFailed = 'Gagal memuat model ML';
  static const String errorImageLoadingFailed = 'Gagal memuat gambar';
  static const String errorInferenceFailed = 'Gagal melakukan inferensi';
  static const String errorInferenceTimeout = 'Inferensi timeout';
  static const String errorNoAvocadoDetected = 'Tidak ada alpukat terdeteksi';
  static const String errorDatabaseFailed = 'Kesalahan database';
  static const String errorStoragePermissionDenied = 'Izin penyimpanan ditolak';
  static const String errorUnknownError = 'Kesalahan tidak diketahui';
  static const String errorNetworkError = 'Kesalahan jaringan';

  // Success Messages
  static const String successScanCompleted = 'Scan selesai';
  static const String successSaved = 'Berhasil disimpan';
  static const String successDeleted = 'Berhasil dihapus';
  static const String successCopiedToClipboard = 'Disalin ke clipboard';
  static const String successShared = 'Berhasil dibagikan';
  static const String successCacheCleared = 'Cache berhasil dibersihkan';

  // Loading Messages
  static const String loadingProcessing = 'Memproses...';
  static const String loadingLoadingModel = 'Memuat model...';
  static const String loadingAnalyzing = 'Menganalisis gambar...';
  static const String loadingSavingResults = 'Menyimpan hasil...';
  static const String loadingLoadingHistory = 'Memuat riwayat...';

  // Confirmation Messages
  static const String confirmDeleteItem = 'Hapus item ini?';
  static const String confirmClearHistory = 'Hapus semua riwayat?';
  static const String confirmExitApp = 'Keluar dari aplikasi?';

  // Placeholders
  static const String placeholderNoResults = 'Tidak ada hasil';
  static const String placeholderSelectOption = 'Pilih opsi';
  static const String placeholderEnterValue = 'Masukkan nilai';

  // Format Strings
  static const String formatDateTime = 'dd/MM/yyyy HH:mm';
  static const String formatDate = 'dd/MM/yyyy';
  static const String formatTime = 'HH:mm:ss';
  static const String formatConfidence = '##.##%';
  static const String formatInferenceTime = '###ms';

  // Units
  static const String unitMilliseconds = 'ms';
  static const String unitSeconds = 's';
  static const String unitPercent = '%';
  static const String unitFps = 'FPS';

  // Other
  static const String skip = 'Lewati';
  static const String done = 'Selesai';
  static const String ok = 'OK';
  static const String close = 'Tutup';
  static const String retry = 'Coba Lagi';
  static const String reload = 'Muat Ulang';
  static const String copy = 'Salin';
  static const String share = 'Bagikan';
  static const String edit = 'Edit';
  static const String search = 'Cari';
  static const String filter = 'Filter';
  static const String sort = 'Urutkan';
  static const String ascending = 'Menaik';
  static const String descending = 'Menurun';
}
