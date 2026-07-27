/// lib/utils/extensions/double_extensions.dart
/// 
/// Extension methods untuk Double dan num
library;

import 'dart:math';

extension DoubleExtensions on double {
  /// Round ke decimal places tertentu
  double roundToPrecision(int decimals) {
    final mod = pow(10, decimals);
    return (this * mod).round() / mod;
  }

  /// Truncate (potong) ke decimal places
  double truncateToPrecision(int decimals) {
    final mod = pow(10, decimals);
    return (this * mod).truncateToDouble() / mod;
  }

  /// Convert ke percentage string
  String toPercentageString({int decimals = 2}) => '${(this * 100).roundToPrecision(decimals)}%';

  /// Check apakah nilai antara min dan max (inclusive)
  bool isBetween(double min, double max) =>
      this >= min && this <= max;

  /// Clamp value antara min dan max
  double clampBetween(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Convert ke miliseconds dari seconds
  int toMilliseconds() => (this * 1000).toInt();

  /// Check apakah nilai adalah positive
  bool get isPositive => this > 0;

  /// Check apakah nilai adalah negative
  bool get isNegative => this < 0;

  /// Check apakah nilai adalah zero
  bool get isZero => this == 0;

  /// Check apakah nilai adalah NaN
  bool get isNaN => this.isNaN;

  /// Check apakah nilai adalah infinite
  bool get isInfinite => this.isInfinite;

  /// Check apakah nilai adalah finite
  bool get isFinite => this.isFinite;

  /// Get absolute value
  double get abs => this.abs();

  /// Get ceiling value
  int get ceil => this.ceil();

  /// Get floor value
  int get floor => this.floor();

  /// Get nearest integer
  int get round => this.round();

  /// Convert ke String dengan presisi
  String toStringWithPrecision(int decimals) => toStringAsFixed(decimals);

  /// Format sebagai waktu (mm:ss)
  String formatAsTime() {
    final minutes = (this / 60).floor();
    final seconds = (this % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

extension NumExtensions on num {
  /// Convert ke double safely
  double toDoubleSafe() => toDouble();

  /// Convert ke int safely
  int toIntSafe() => toInt();

  /// Format dengan separator ribuan
  String formatWithSeparator({String separator = ','}) => toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => separator,
    );

  /// Convert ke bytes (approximate)
  String toFileSizeString() {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var bytes = toDouble();
    var index = 0;
    while (bytes >= 1024 && index < suffixes.length - 1) {
      bytes /= 1024;
      index++;
    }
    return '${bytes.toStringAsFixed(2)} ${suffixes[index]}';
  }
}

extension IntExtensions on int {
  /// Check apakah number adalah even
  bool get isEven => this % 2 == 0;

  /// Check apakah number adalah odd
  bool get isOdd => this % 2 != 0;

  /// Convert ke 2-digit string
  String twoDigits() => toString().padLeft(2, '0');

  /// Convert ke duration
  Duration toDuration({
    bool isMilliseconds = false,
    bool isSeconds = true,
    bool isMinutes = false,
    bool isHours = false,
  }) {
    if (isMilliseconds) return Duration(milliseconds: this);
    if (isSeconds) return Duration(seconds: this);
    if (isMinutes) return Duration(minutes: this);
    if (isHours) return Duration(hours: this);
    return Duration(seconds: this);
  }

  /// Check apakah number antara min dan max (inclusive)
  bool isBetween(int min, int max) => this >= min && this <= max;

  /// Repeat action n times
  Iterable<int> get range => Iterable<int>.generate(this);

  /// Get factorial
  int get factorial {
    if (this < 0) throw ArgumentError('Factorial not defined for negative numbers');
    if (this == 0 || this == 1) return 1;
    return this * (this - 1).factorial;
  }
}
