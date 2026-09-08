import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'services/access_log_service.dart';
import 'services/preferences_service.dart';

class FrutiApp extends StatelessWidget {
  FrutiApp({super.key});

  final AccessLogService logService = AccessLogService();
  final PreferencesService preferencesService = PreferencesService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FrutiApp Web',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(
        logService: logService,
        preferencesService: preferencesService,
      ),
    );
  }
}