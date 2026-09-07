import 'package:flutter_test/flutter_test.dart';
import 'package:frutiapp_web/models/access_record.dart';

void main() {
  test('AccessRecord convierte correctamente a JSON', () {
    final registro = AccessRecord(
      usuario: 'admin@frutiapp.com',
      fechaHora: DateTime(2026, 9, 7, 10, 30),
      exitoso: true,
    );

    final json = registro.toJson();

    expect(json['usuario'], 'admin@frutiapp.com');
    expect(json['exitoso'], true);
    expect(json['fechaHora'], '2026-09-07T10:30:00.000');
  });

  test('AccessRecord se reconstruye correctamente desde JSON', () {
    final json = {
      'usuario': 'usuario@correo.com',
      'fechaHora': '2026-09-07T12:00:00.000',
      'exitoso': false,
    };

    final registro = AccessRecord.fromJson(json);

    expect(registro.usuario, 'usuario@correo.com');
    expect(registro.exitoso, false);
    expect(
      registro.fechaHora,
      DateTime(2026, 9, 7, 12, 0),
    );
  });
}