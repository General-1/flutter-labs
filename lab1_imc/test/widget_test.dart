import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab1_imc/main.dart';

void main() {
  test('calculeazaImc', () {
    expect(calculeazaImc(70, 175), closeTo(22.86, 0.01));
  });

  test('categorieImc', () {
    expect(categorieImc(17), 'Subponderal');
    expect(categorieImc(22), 'Greutate normală');
    expect(categorieImc(27), 'Supraponderal');
    expect(categorieImc(32), 'Obezitate gradul I');
    expect(categorieImc(37), 'Obezitate gradul II');
    expect(categorieImc(42), 'Obezitate gradul III');
  });

  testWidgets('afișează IMC și categoria după apăsarea butonului',
      (tester) async {
    await tester.pumpWidget(const ImcApp());

    await tester.enterText(find.byType(TextField).at(0), '70');
    await tester.enterText(find.byType(TextField).at(1), '175');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('IMC: 22.9'), findsOneWidget);
    expect(find.text('Categoria: Greutate normală'), findsOneWidget);
  });

  testWidgets('afișează eroare pentru valori invalide', (tester) async {
    await tester.pumpWidget(const ImcApp());

    await tester.enterText(find.byType(TextField).at(0), 'abc');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Introduceți valori numerice valide.'), findsOneWidget);
  });
}
