/// lib/domain/entities/avocado_class.dart
/// 
/// Enum untuk klasifikasi kematangan alpukat
/// Pure domain entity, no framework dependencies
library;

enum AvocadoClass {
  mentah,           // Unripe
  setengahMatang,   // Half-ripe
  matang,           // Ripe
  busuk,            // Rotten
  unknown,          // Unknown
}

extension AvocadoClassExtension on AvocadoClass {
  /// Get display name in Indonesian
  String get displayName {
    switch (this) {
      case AvocadoClass.mentah:
        return 'Mentah';
      case AvocadoClass.setengahMatang:
        return 'Setengah Matang';
      case AvocadoClass.matang:
        return 'Matang';
      case AvocadoClass.busuk:
        return 'Busuk';
      case AvocadoClass.unknown:
        return 'Tidak Diketahui';
    }
  }

  /// Get description
  String get description {
    switch (this) {
      case AvocadoClass.mentah:
        return 'Buah masih keras dan belum matang. Butuh beberapa hari untuk siap dikonsumsi.';
      case AvocadoClass.setengahMatang:
        return 'Buah sedang dalam proses pematangan. Siap dikonsumsi dalam 1-2 hari.';
      case AvocadoClass.matang:
        return 'Buah sudah matang dan siap untuk dikonsumsi.';
      case AvocadoClass.busuk:
        return 'Buah sudah rusak atau membusuk. Sebaiknya dibuang.';
      case AvocadoClass.unknown:
        return 'Status kematangan tidak dapat ditentukan.';
    }
  }

  /// Get recommendation
  String get recommendation {
    switch (this) {
      case AvocadoClass.mentah:
        return 'Simpan di tempat sejuk dan cek kembali dalam beberapa hari.';
      case AvocadoClass.setengahMatang:
        return 'Simpan di suhu ruangan untuk mempercepat pematangan.';
      case AvocadoClass.matang:
        return 'Segera konsumsi atau simpan di kulkas untuk memperlama kesegaran.';
      case AvocadoClass.busuk:
        return 'Sebaiknya dibuang karena tidak layak dikonsumsi.';
      case AvocadoClass.unknown:
        return 'Posisikan ulang buah dan coba scan kembali.';
    }
  }

  /// Get color representation (Material Design 3)
  String get colorHex {
    switch (this) {
      case AvocadoClass.mentah:
        return '#66BB6A';  // Green - Light
      case AvocadoClass.setengahMatang:
        return '#FDD835';  // Amber - Yellow
      case AvocadoClass.matang:
        return '#43A047';  // Green - Dark
      case AvocadoClass.busuk:
        return '#EF5350';  // Red
      case AvocadoClass.unknown:
        return '#9E9E9E';  // Grey
    }
  }

  /// Get icon representation
  String get icon {
    switch (this) {
      case AvocadoClass.mentah:
        return '🥒';  // Pickle/Unripe
      case AvocadoClass.setengahMatang:
        return '🥑';  // Avocado
      case AvocadoClass.matang:
        return '✅';  // Checkmark
      case AvocadoClass.busuk:
        return '❌';  // Cross
      case AvocadoClass.unknown:
        return '❓';  // Question mark
    }
  }

  /// Convert string to AvocadoClass
  static AvocadoClass fromString(String value) {
    switch (value.toLowerCase().trim()) {
      case 'mentah':
      case '0':
        return AvocadoClass.mentah;
      case 'setengah matang':
      case 'setengahmatang':
      case '1':
        return AvocadoClass.setengahMatang;
      case 'matang':
      case '2':
        return AvocadoClass.matang;
      case 'busuk':
      case '3':
        return AvocadoClass.busuk;
      default:
        return AvocadoClass.unknown;
    }
  }

  /// Get all available classes
  static List<AvocadoClass> get availableClasses => [
        AvocadoClass.mentah,
        AvocadoClass.setengahMatang,
        AvocadoClass.matang,
        AvocadoClass.busuk,
      ];
}
