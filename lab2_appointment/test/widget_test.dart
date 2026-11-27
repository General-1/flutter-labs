import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab2_appointment/main.dart';
import 'package:lab2_appointment/models/doctor.dart';
import 'package:lab2_appointment/screens/appointment_details_screen.dart';

/// Rulează testele pe un ecran de telefon (360x800), nu pe 800x600 implicit.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

void main() {
  test('Doctor.initials', () {
    expect(upcomingDoctor.initials, 'RK');
    expect(nearbyDoctors[2].initials, 'U'); // „Dr.Upul”
  });

  testWidgets('Homescreen afișează secțiunile și doctorii', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const DoctorApp());

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Dr. Richar Kandowen'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(find.text('Tooth'), findsOneWidget);
    expect(find.text('Nearby Doctor'), findsOneWidget);
  });

  testWidgets('search-ul filtrează lista de doctori', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const DoctorApp());

    await tester.enterText(find.byType(TextField), 'sonja');
    await tester.pump();

    expect(find.text('Dr. Sonja Littel', skipOffstage: false), findsOneWidget);
    expect(find.text('Dr. Emmly Lestiryno', skipOffstage: false), findsNothing);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pump();
    expect(find.text('No doctors found for "xyz"', skipOffstage: false),
        findsOneWidget);
  });

  testWidgets('tap pe card deschide detaliile, Back revine', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const DoctorApp());

    await tester.tap(find.text('Dr. Richar Kandowen'));
    await tester.pumpAndSettle();

    expect(find.text('Book an Appointment'), findsOneWidget);
    expect(find.text('Child Specialist'), findsOneWidget);
    expect(find.text('\$90.00'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Book an Appointment'), findsNothing);
    expect(find.text('Hi, Jonathan'), findsOneWidget);
  });

  testWidgets('alegerea orei/zilei apare în confirmarea programării',
      (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(
      MaterialApp(home: AppointmentDetailsScreen(doctor: nearbyDoctors[2])),
    );

    // Chip-urile pot fi sub marginea ecranului — derulăm până la ele.
    for (final label in ['12.00 PM', 'Mon 5']) {
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pump();
    }

    await tester.tap(find.text('Book an Appointment'));
    await tester.pumpAndSettle();

    expect(find.text('Appointment booked'), findsOneWidget);
    expect(find.textContaining('Mon 5 at 12.00 PM'), findsOneWidget);
    expect(find.textContaining('\$120.00'), findsWidgets);
  });
}
