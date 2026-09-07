import 'package:flutter/material.dart';

import '../models/access_record.dart';
import '../services/access_log_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final AccessLogService logService;

  const LoginPage({
    super.key,
    required this.logService,
  });

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

    widget.logService.add(
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
        MaterialPageRoute(
          builder: (context) => HomePage(
            logService: widget.logService,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo o contraseña incorrectos'),
        ),
      );
    }
  }

  @override
  void dispose() {
    correoController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
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

                    // Correo
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

                    // Contraseña
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

                    // Recordarme
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

                    // Ingresar
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