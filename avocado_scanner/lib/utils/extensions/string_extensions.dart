/// lib/utils/extensions/string_extensions.dart
/// 
/// Extension methods untuk String
library;

import 'dart:math';

extension StringExtensions on String {
  /// Check apakah string adalah kosong atau hanya whitespace
  bool get isNullOrEmpty => isEmpty || trim().isEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isNullOrEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Reverse string
  String get reverse => split('').reversed.join();

  /// Check apakah string adalah valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check apakah string adalah valid URL
  bool get isValidUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check apakah string adalah numeric
  bool get isNumeric => num.tryParse(this) != null;

  /// Convert string ke integer
  int? toIntOrNull() => int.tryParse(this);

  /// Convert string ke double
  double? toDoubleOrNull() => double.tryParse(this);

  /// Repeat string n times
  String repeat(int count) {
    if (count <= 0) return '';
    if (count == 1) return this;
    return List.filled(count, this).join();
  }

  /// Check apakah string contains substring (case insensitive)
  bool containsIgnoreCase(String other) =>
      toLowerCase().contains(other.toLowerCase());

  /// Truncate string dengan ellipsis
  String truncate(int length, {String ellipsis = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$ellipsis';
  }

  /// Remove all whitespace
  String removeWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Convert camelCase to snake_case
  String toSnakeCase() => replaceAllMapped(
      RegExp(r'(?<=[a-z])[A-Z]'),
      (match) => '_${match.group(0)}',
    ).toLowerCase();

  /// Convert snake_case to camelCase
  String toCamelCase() => split('_').asMap().entries.map((entry) {
      final value = entry.value;
      final index = entry.key;
      return index == 0 ? value : value.capitalize;
    }).join();

  /// Format as currency (IDR)
  String formatCurrency({String prefix = 'Rp '}) => '$prefix${num.parse(replaceAll(RegExp(r'[^0-9]'), '')).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';

  /// Get initials from name
  String getInitials({int maxLength = 2}) {
    final parts = trim().split(' ');
    final initials = parts.map((p) => p.isEmpty ? '' : p[0]).join();
    return initials.substring(0, min(initials.length, maxLength)).toUpperCase();
  }

  /// Check string length with condition
  bool isLengthBetween(int min, int max) =>
      length >= min && length <= max;
}
