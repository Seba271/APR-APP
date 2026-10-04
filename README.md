# APR Terreno

Mockup funcional en Flutter Web para registrar muestras de agua en terreno. Está diseñado para operadores de APR y dirigentes vecinales sin formación técnica especializada.

## Flujo incluido

- Inicio de sesión demostrativo.
- Resumen de tareas y alertas.
- Registro guiado de una muestra en cuatro pasos.
- Validación simple de pH y cloro residual.
- Evidencias y observaciones.
- Historial de registros enviados, pendientes y guardados sin conexión.
- Ayuda con instrucciones breves.

## Ejecutar localmente

```bash
flutter pub get
flutter run -d chrome
```

## Generar versión web

```bash
flutter build web --release
```

La carpeta `build/web` puede publicarse como un sitio estático.
