import 'package:flutter_test/flutter_test.dart';
import 'package:frutiapp_web/models/access_record.dart';
import 'package:frutiapp_web/services/access_log_service.dart';

void main() {
  group('AccessLogService', () {
    test('agrega registros correctamente', () {
      final service = AccessLogService();

      service.add(
        AccessRecord(
          usuario: 'admin@frutiapp.com',
          fechaHora: DateTime(2026, 9, 8, 10, 0),
          exitoso: true,
        ),
      );

      expect(service.records.length, 1);
      expect(service.records.first.usuario, 'admin@frutiapp.com');
      expect(service.records.first.exitoso, true);
    });

    test('exporta registros a JSON', () {
      final service = AccessLogService();

      service.add(
        AccessRecord(
          usuario: 'admin@frutiapp.com',
          fechaHora: DateTime(2026, 9, 8, 10, 0),
          exitoso: true,
        ),
      );

      final json = service.exportJson();

      expect(json, contains('admin@frutiapp.com'));
      expect(json, contains('"exitoso": true'));
    });

    test('importa un JSON válido', () {
      final service = AccessLogService();

      const json = '''
[
  {
    "usuario": "usuario@correo.com",
    "fechaHora": "2026-09-08T10:00:00.000",
    "exitoso": true
  }
]
''';

      service.importJson(json);

      expect(service.records.length, 1);
      expect(service.records.first.usuario, 'usuario@correo.com');
      expect(service.records.first.exitoso, true);
    });

    test('rechaza un archivo vacío', () {
      final service = AccessLogService();

      expect(
        () => service.importJson(''),
        throwsA(isA<FormatException>()),
      );
    });

    test('rechaza JSON que no contiene una lista', () {
      final service = AccessLogService();

      const json = '''
{
  "usuario": "admin@frutiapp.com"
}
''';

      expect(
        () => service.importJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('rechaza un registro con formato incorrecto', () {
      final service = AccessLogService();

      const json = '''
[
  "registro incorrecto"
]
''';

      expect(
        () => service.importJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('limpia todos los registros', () {
      final service = AccessLogService();

      service.add(
        AccessRecord(
          usuario: 'admin@frutiapp.com',
          fechaHora: DateTime.now(),
          exitoso: true,
        ),
      );

      service.clear();

      expect(service.records, isEmpty);
    });
  });
}