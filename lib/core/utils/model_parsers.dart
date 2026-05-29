import 'package:cloud_firestore/cloud_firestore.dart';

class ModelParsers {
  static DateTime parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ??
          DateTime.now();
    }

    return DateTime.now();
  }

  static double parseDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0.0;
  }

  static int parseInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static bool parseBool(dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    return value.toString().toLowerCase() ==
        'true';
  }
}