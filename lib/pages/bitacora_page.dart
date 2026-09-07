import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../services/access_log_service.dart';

class BitacoraPage extends StatefulWidget {
  final AccessLogService logService;

  const BitacoraPage({
    super.key,
    required this.logService,
  });

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  Future<void> importarBitacora() async {
    const typeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: [typeGroup],
    );

    if (file == null) {
      return;
    }

    try {
      final contenido = await file.readAsString();

      widget.logService.importJson(contenido);

      if (!mounted) {
        return;
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bitácora importada correctamente',
          ),
        ),
      );
    } on FormatException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'JSON inválido: ${e.message}',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo leer el archivo',
          ),
        ),
      );
    }
  }

  void descargarJson(String contenido) {
    final base64 = base64Encode(
      utf8.encode(contenido),
    );

    web.HTMLAnchorElement()
      ..href = 'data:application/json;base64,$base64'
      ..setAttribute(
        'download',
        'bitacora_accesos.json',
      )
      ..click();
  }

  void exportarBitacora() {
    descargarJson(
      widget.logService.exportJson(),
    );
  }

  void limpiarBitacora() {
    setState(() {
      widget.logService.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final registros = widget.logService.records;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bitácora de accesos',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: exportarBitacora,
                  icon: const Icon(
                    Icons.download,
                  ),
                  label: const Text(
                    'Exportar JSON',
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: importarBitacora,
                  icon: const Icon(
                    Icons.upload_file,
                  ),
                  label: const Text(
                    'Importar JSON',
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: limpiarBitacora,
                  icon: const Icon(
                    Icons.delete,
                  ),
                  label: const Text(
                    'Limpiar',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: registros.isEmpty
                ? const Center(
                    child: Text(
                      'No hay registros todavía',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      final registro = registros[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: ListTile(
                          leading: Icon(
                            registro.exitoso
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: registro.exitoso
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(
                            registro.usuario.isEmpty
                                ? '(sin usuario)'
                                : registro.usuario,
                          ),
                          subtitle: Text(
                            registro.fechaHora.toString(),
                          ),
                          trailing: Text(
                            registro.exitoso
                                ? 'OK'
                                : 'FALLÓ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: registro.exitoso
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}