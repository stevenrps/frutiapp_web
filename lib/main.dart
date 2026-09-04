import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/access_record.dart';
import 'services/access_log_service.dart';

import 'package:file_selector/file_selector.dart';
import 'package:web/web.dart' as web;

final logService = AccessLogService();

void main() {
  runApp(const FrutiApp());
}

class FrutiApp extends StatelessWidget {
  const FrutiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FrutiApp Web',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final correoController = TextEditingController();
  final passwordController = TextEditingController();

  bool recordarme = false;

  void ingresar() {
    final formularioValido = _formKey.currentState!.validate();

    final usuario = correoController.text.trim();
    final password = passwordController.text;

    final credencialesCorrectas =
        usuario == 'admin@frutiapp.com' && password == '123456';

    final exitoso = formularioValido && credencialesCorrectas;

    logService.add(
      AccessRecord(
        usuario: usuario,
        fechaHora: DateTime.now(),
        exitoso: exitoso,
      ),
    );

    if (!formularioValido) {
      return;
    }

    if (exitoso) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_grocery_store,
                      size: 70,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'FrutiApp',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TextFormField(
                      controller: correoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el correo';
                        }

                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Correo no válido';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Checkbox(
                          value: recordarme,
                          onChanged: (value) {
                            setState(() {
                              recordarme = value ?? false;
                            });
                          },
                        ),
                        const Text('Recordarme'),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ingresar,
                        child: const Text('Ingresar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> productos;

  @override
  void initState() {
    super.initState();
    productos = cargarProductos();
  }

  Future<List<dynamic>> cargarProductos() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('No se pudo cargar la información');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FrutiApp - Catálogo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Bitácora',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BitacoraPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('No se pudo cargar la información.'),
            );
          }

          final lista = snapshot.data!;

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final producto = lista[index];

              final nombre = producto['title'];
              final id = producto['id'];
              final precio = id * 100;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.shopping_basket),
                  title: Text(nombre),
                  subtitle: Text('Precio: ₡$precio'),
                  trailing: Text('ID: $id'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

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

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file == null) return;

    try {
      final contenido = await file.readAsString();

      logService.importJson(contenido);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitácora importada correctamente')),
      );
    } on FormatException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('JSON inválido: ${e.message}')));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo leer el archivo')),
      );
    }
  }

  void descargarJson(String contenido) {
    final base64 = base64Encode(utf8.encode(contenido));

    web.HTMLAnchorElement()
      ..href = 'data:application/json;base64,$base64'
      ..setAttribute('download', 'bitacora_accesos.json')
      ..click();
  }

  void exportarBitacora() {
    descargarJson(logService.exportJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de accesos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: exportarBitacora,
                  icon: const Icon(Icons.download),
                  label: const Text('Exportar JSON'),
                ),

                const SizedBox(width: 12),

                OutlinedButton.icon(
                  onPressed: importarBitacora,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Importar JSON'),
                ),
                const SizedBox(width: 12),

                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      logService.clear();
                    });
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
          ),

          Expanded(
            child: logService.records.isEmpty
                ? const Center(
                    child: Text(
                      'No hay registros todavía',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: logService.records.length,
                    itemBuilder: (context, index) {
                      final registro = logService.records[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Icon(
                            registro.exitoso
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: registro.exitoso ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            registro.usuario.isEmpty
                                ? '(sin usuario)'
                                : registro.usuario,
                          ),
                          subtitle: Text(registro.fechaHora.toString()),
                          trailing: Text(
                            registro.exitoso ? 'OK' : 'FALLÓ',
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
