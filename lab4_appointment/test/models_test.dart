import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_appointment/data/models/appointment_details_model.dart';
import 'package:lab4_appointment/data/models/home_feed_model.dart';
import 'package:lab4_appointment/domain/entities/doctor.dart';

import 'helpers.dart';

void main() {
  test('GET /feed: JSON → model → entitate', () {
    expect(sampleFeed.user.greeting, 'Hi, Jonathan');
    expect(sampleFeed.hasUnreadNotifications, isTrue);
    expect(sampleFeed.appointment.doctor.name, 'Dr. Richar Kandowen');
    expect(sampleFeed.healthServices.map((s) => s.name), [
      'Tooth',
      'Eye',
      'Lungs',
      'Ear',
    ]);
    expect(sampleFeed.nearbyDoctors.map((d) => d.id), [
      'doctor-001',
      'doctor-002',
    ]);
  });

  test('GET /feed/details: JSON → model → entitate', () {
    expect(sampleDetails.paymentFormatted, r'$120.00');
    expect(sampleDetails.workingHours.slots, hasLength(3));
    expect(sampleDetails.workingHours.initialSlot?.id, '11am');
    expect(sampleDetails.dates.initialSlot?.id, 'sun-4');
    expect(sampleDetails.doctor.canVideoCall, isTrue);
  });

  test('serializarea reface exact JSON-ul primit', () {
    final feed = fixtureJson(feedFixture);
    final details = fixtureJson(detailsFixture);

    expect(HomeFeedModel.fromJson(feed).toJson(), feed);
    expect(AppointmentDetailsModel.fromJson(details).toJson(), details);
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
