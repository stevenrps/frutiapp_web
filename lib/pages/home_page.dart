import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/access_log_service.dart';
import 'bitacora_page.dart';

class HomePage extends StatefulWidget {
  final AccessLogService logService;

  const HomePage({
    super.key,
    required this.logService,
  });

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
      Uri.parse(
        'https://jsonplaceholder.typicode.com/posts',
      ),
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
                MaterialPageRoute(
                  builder: (context) => BitacoraPage(
                    logService: widget.logService,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'No se pudo cargar la información.',
              ),
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_basket,
                  ),
                  title: Text(nombre),
                  subtitle: Text(
                    'Precio: ₡$precio',
                  ),
                  trailing: Text(
                    'ID: $id',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}