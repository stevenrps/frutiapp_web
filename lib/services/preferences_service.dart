import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _recordarmeKey = 'recordarme';
  static const String _usuarioKey = 'usuario_recordado';

  Future<void> guardarUsuario({
    required String usuario,
    required bool recordarme,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_recordarmeKey, recordarme);

    if (recordarme) {
      await prefs.setString(_usuarioKey, usuario);
    } else {
      await prefs.remove(_usuarioKey);
    }
  }

  Future<bool> obtenerRecordarme() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_recordarmeKey) ?? false;
  }

  Future<String?> obtenerUsuario() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_usuarioKey);
  }

  Future<void> limpiarUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_usuarioKey);
    await prefs.setBool(_recordarmeKey, false);
  }
}