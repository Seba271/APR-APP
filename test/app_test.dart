import 'package:apr_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el acceso abre el inicio y permite comenzar una muestra', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AprTerrenoApp());

    expect(find.text('APR Terreno'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.ensureVisible(find.text('Iniciar sesión'));
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Juan 👋'), findsOneWidget);
    expect(find.text('Comenzar registro'), findsOneWidget);

    await tester.ensureVisible(find.text('Comenzar registro'));
    await tester.tap(find.text('Comenzar registro'));
    await tester.pumpAndSettle();

    expect(find.text('Paso 1 de 4'), findsOneWidget);
    expect(find.text('Lugar de la muestra'), findsOneWidget);
    expect(find.byIcon(Icons.location_on_outlined), findsWidgets);
  });
}
