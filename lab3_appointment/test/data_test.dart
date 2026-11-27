import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_appointment/data/appointment_repository.dart';
import 'package:lab3_appointment/models/doctor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AssetAppointmentRepository repository([String? path]) =>
      AssetAppointmentRepository(
        assetPath: path ?? AssetAppointmentRepository.defaultAsset,
        delay: Duration.zero,
      );

  test('citește Homescreen-ul din fișierul JSON', () async {
    final feed = await repository().loadHomeFeed();

    expect(feed.user.greeting, 'Hi, Jonathan');
    expect(feed.hasUnreadNotifications, isTrue);
    expect(feed.appointment.doctor.name, 'Dr. Richar Kandowen');
    expect(feed.healthServices.map((s) => s.name), [
      'Tooth',
      'Eye',
      'Lungs',
      'Ear',
    ]);
    expect(feed.nearbyDoctors.map((d) => d.id), ['doctor-001', 'doctor-002']);
  });

  test('citește detaliile din fișierul JSON', () async {
    final details = await repository().loadAppointmentDetails();

    expect(details.paymentFormatted, r'$120.00');
    expect(details.workingHours.slots, hasLength(3));
    expect(details.workingHours.initialSlot?.id, '11am');
    expect(details.dates.initialSlot?.id, 'sun-4');
    expect(details.doctor.canVideoCall, isTrue);
  });

  test('fișierul demo pentru Empty nu are doctori', () async {
    final feed = await repository('assets/data/lab_v2_empty.json')
        .loadHomeFeed();

    expect(feed.nearbyDoctors, isEmpty);
  });

  test('un fișier lipsă produce o eroare', () {
    expect(
      repository('assets/data/missing.json').loadHomeFeed(),
      throwsA(anything),
    );
  });

  test('Doctor: inițiale și distanța în metri', () {
    const doctor = Doctor(
      name: 'Dr. Sonja Litel',
      specialty: 'Dental Specialist',
      distance: '950 Sigrid Port - 753M from you',
    );

    expect(doctor.initials, 'SL');
    expect(doctor.distanceInMeters, 753);
    expect(
      const Doctor(
        name: 'A',
        specialty: 'B',
        distance: '12 Galle Road - 1.4KM from you',
      ).distanceInMeters,
      1400,
    );
    expect(const Doctor(name: 'A', specialty: 'B').distanceInMeters, isNull);
  });
}
