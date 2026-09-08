# FrutiApp Web

Proyecto desarrollado en Flutter Web para el curso IF0009 - Desarrollo de Software IV.

## Descripción

FrutiApp es una aplicación web que incluye:

- Inicio de sesión con validación básica.
- Registro de intentos de acceso.
- Bitácora de accesos exitosos y fallidos.
- Persistencia de preferencias mediante SharedPreferences.
- Opción "Recordarme" para conservar el correo del usuario.
- Importación de bitácoras desde archivos JSON.
- Exportación de la bitácora a archivos JSON.
- Consumo de información mediante HTTP.
- Manejo de errores en archivos JSON.
- Pruebas automatizadas.

## Credenciales de prueba

Correo:

admin@frutiapp.com

Contraseña:

123456

La contraseña se utiliza únicamente para la validación simulada y no se almacena en SharedPreferences ni en los archivos JSON.

## Estructura del proyecto

lib/
├── models/
│   └── access_record.dart
│
├── pages/
│   ├── login_page.dart
│   ├── home_page.dart
│   └── bitacora_page.dart
│
├── services/
│   ├── access_log_service.dart
│   ├── json_file_service.dart
│   └── preferences_service.dart
│
├── app.dart
└── main.dart

## Persistencia

### SharedPreferences

Se utiliza únicamente para almacenar preferencias simples:

- Estado de la opción "Recordarme".
- Correo electrónico recordado.

No se almacena la contraseña.

### JSON

La bitácora de accesos se serializa a formato JSON.

Cada registro contiene:

- Usuario.
- Fecha y hora.
- Resultado del intento de acceso.

Ejemplo:

[
  {
    "usuario": "admin@frutiapp.com",
    "fechaHora": "2026-09-08T10:00:00.000",
    "exitoso": true
  }
]

## Importación y exportación

La aplicación permite:

- Seleccionar e importar archivos .json.
- Exportar la bitácora como bitacora_accesos.json.
- Detectar archivos vacíos.
- Detectar JSON inválido.
- Detectar registros con formato incorrecto.

Para Flutter Web se utiliza file_selector para seleccionar archivos y package:web para generar la descarga.

## Pruebas

Se incluyeron pruebas para verificar:

- Serialización de AccessRecord.
- Deserialización de AccessRecord.
- Registro de accesos.
- Exportación JSON.
- Importación JSON válida.
- Rechazo de archivos vacíos.
- Rechazo de JSON inválido.
- Limpieza de la bitácora.

Para ejecutar las pruebas:

flutter analyze
flutter test

## Ejecución

Para ejecutar el proyecto en Chrome:

flutter pub get
flutter run -d chrome

## Tecnologías utilizadas

- Flutter Web
- Dart
- SharedPreferences
- JSON
- file_selector
- package:web
- HTTP
- Git