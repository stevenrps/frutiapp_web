import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:web/web.dart' as web;

class JsonFileService {
  Future<String?> seleccionarJson() async {
    const typeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: [typeGroup],
    );

    if (file == null) {
      return null;
    }

    return file.readAsString();
  }

  void descargarJson({
    required String contenido,
    required String nombreArchivo,
  }) {
    final base64 = base64Encode(
      utf8.encode(contenido),
    );

    web.HTMLAnchorElement()
      ..href = 'data:application/json;base64,$base64'
      ..setAttribute(
        'download',
        nombreArchivo,
      )
      ..click();
  }
}