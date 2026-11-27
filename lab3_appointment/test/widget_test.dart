import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_appointment/app.dart';
import 'package:lab3_appointment/data/appointment_repository.dart';

import 'helpers.dart';

/// Rulează testele pe un ecran de telefon (360x800), nu pe 800x600 implicit.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

/// Pornește aplicația și, dacă nu se cere altfel, așteaptă încărcarea.
Future<void> pumpApp(
  WidgetTester tester,
  AppointmentRepository repository, {
  bool settle = true,
}) async {
  usePhoneScreen(tester);
  await tester.pumpWidget(DoctorApp(repository: repository));
  if (settle) await tester.pumpAndSettle();
}

/// Derulează până la widget și apasă pe el.
Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Un doctor din lista „Nearby Doctor”, chiar dacă e sub marginea ecranului.
Finder listed(String text) => find.text(text, skipOffstage: false);

void main() {
  testWidgets('Loading, apoi Success', (tester) async {
    final gate = Completer<void>();
    await pumpApp(tester, FakeRepository(gate: gate), settle: false);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    gate.complete();
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Dr. Richar Kandowen'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(listed('Dr. Emmly Lestiryno'), findsOneWidget);
    expect(listed('Dr. Sonja Litel'), findsOneWidget);
  });

  testWidgets('aplicația pornește cu fișierul JSON real', (tester) async {
    await pumpApp(tester, AssetAppointmentRepository(delay: Duration.zero));

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(listed('Dr. Sonja Litel'), findsOneWidget);
  });

  testWidgets('starea Empty', (tester) async {
    await pumpApp(tester, FakeRepository(feed: emptyFeed));

    expect(find.text('No doctors available yet'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
  });

  testWidgets('starea Error și „Try again”', (tester) async {
    final repository = FakeRepository()..failHome = true;
    await pumpApp(tester, repository);

    expect(find.text('Could not load the data.'), findsOneWidget);

    repository.failHome = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Jonathan'), findsOneWidget);
  });

  testWidgets('căutarea filtrează lista și poate fi ștearsă', (tester) async {
    await pumpApp(tester, FakeRepository());

    await tester.enterText(find.byType(TextField), 'sonja');
    await tester.pumpAndSettle();
    expect(listed('Dr. Sonja Litel'), findsOneWidget);
    expect(listed('Dr. Emmly Lestiryno'), findsNothing);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();
    expect(listed('No doctors match your search or filters'), findsOneWidget);

    await scrollAndTap(tester, listed('Clear search and filters'));
    expect(listed('Dr. Emmly Lestiryno'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byType(TextField, skipOffstage: false))
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets('filtrare și sortare din panoul de jos', (tester) async {
    await pumpApp(tester, FakeRepository());

    await tester.tap(find.byTooltip('Filter and sort'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Dental Specialist'));
    await tester.pumpAndSettle();
    expect(listed('Dr. Emmly Lestiryno'), findsNothing);

    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Name Z–A'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final sonja = tester.getTopLeft(listed('Dr. Sonja Litel')).dy;
    final emmly = tester.getTopLeft(listed('Dr. Emmly Lestiryno')).dy;
    expect(sonja, lessThan(emmly));
  });

  testWidgets('favorite: adăugare și filtrul „Favorites only”', (tester) async {
    await pumpApp(tester, FakeRepository());

    // Primul rând este Dr. Emmly.
    await scrollAndTap(
      tester,
      find.byTooltip('Add to favorites', skipOffstage: false).first,
    );
    expect(
      find.byTooltip('Remove from favorites', skipOffstage: false),
      findsOneWidget,
    );

    await tester.drag(find.byType(ListView), const Offset(0, 1000));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Filter and sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorites only'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(listed('Dr. Emmly Lestiryno'), findsOneWidget);
    expect(listed('Dr. Sonja Litel'), findsNothing);
  });

  testWidgets('doctor din listă → detalii → Back', (tester) async {
    await pumpApp(tester, FakeRepository());

    await scrollAndTap(tester, listed('Dr. Sonja Litel'));

    expect(find.text('Book an Appointment'), findsOneWidget);
    expect(find.text('Dr. Sonja Litel'), findsOneWidget);
    expect(find.text('Dental Specialist'), findsOneWidget);
    expect(find.text(r'$120.00'), findsOneWidget);
    expect(find.byTooltip('Video call'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Book an Appointment'), findsNothing);
    expect(listed('Nearby Doctor'), findsOneWidget);
  });

  testWidgets('cardul „Appointment”: alegerea orei și zilei, programare', (
    tester,
  ) async {
    await pumpApp(tester, FakeRepository());

    await tester.tap(find.text('Dr. Richar Kandowen'));
    await tester.pumpAndSettle();
    expect(find.text('Child Specialist'), findsOneWidget);

    await scrollAndTap(tester, find.text('12.00 PM'));
    await scrollAndTap(tester, find.text('Mon 5'));
    await tester.tap(find.text('Book an Appointment'));
    await tester.pumpAndSettle();

    expect(find.text('Appointment booked'), findsOneWidget);
    expect(find.textContaining('Mon 5 at 12.00 PM'), findsOneWidget);
    expect(find.textContaining(r'Payment: $120.00'), findsOneWidget);
  });

  testWidgets('eroare pe ecranul de detalii și „Try again”', (tester) async {
    final repository = FakeRepository()..failDetails = true;
    await pumpApp(tester, repository);

    await tester.tap(find.text('Dr. Richar Kandowen'));
    await tester.pumpAndSettle();
    expect(find.text('Could not load the details.'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsNothing);

    repository.failDetails = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Book an Appointment'), findsOneWidget);
  });
}
