import 'dart:convert';

import '../models/access_record.dart';

class AccessLogService {
  final List<AccessRecord> _records = [];

  List<AccessRecord> get records => List.unmodifiable(_records);

  bool get isEmpty => _records.isEmpty;

  void add(AccessRecord record) {
    _records.add(record);
  }

  void clear() {
    _records.clear();
  }

  String exportJson() {
    final data = _records
        .map((record) => record.toJson())
        .toList();

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  void importJson(String source) {
    if (source.trim().isEmpty) {
      throw const FormatException(
        'El archivo JSON está vacío',
      );
    }

    final dynamic decoded = jsonDecode(source);

    if (decoded is! List) {
      throw const FormatException(
        'El JSON debe contener una lista de registros',
      );
    }

    final List<AccessRecord> loaded = [];

    for (int i = 0; i < decoded.length; i++) {
      final item = decoded[i];

      if (item is! Map) {
        throw FormatException(
          'El registro ${i + 1} no es un objeto JSON válido',
        );
      }

      try {
        final json = Map<String, dynamic>.from(item);

        loaded.add(
          AccessRecord.fromJson(json),
        );
      } on FormatException catch (e) {
        throw FormatException(
          'Error en el registro ${i + 1}: ${e.message}',
        );
      } on TypeError {
        throw FormatException(
          'El registro ${i + 1} contiene datos con tipos incorrectos',
        );
      } catch (_) {
        throw FormatException(
          'El registro ${i + 1} no tiene el formato esperado',
        );
      }
    }

    _records
      ..clear()
      ..addAll(loaded);
  }
}