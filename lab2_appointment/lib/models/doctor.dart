/// Un doctor afișat în aplicație.
class Doctor {
  const Doctor({
    required this.name,
    required this.specialty,
    required this.address,
    required this.fee,
    this.about = loremDetails,
  });

  final String name;
  final String specialty;
  final String address;
  final double fee;
  final String about;

  /// Inițialele folosite în avatarul placeholder („Dr. Sonja Littel” → „SL”).
  String get initials => name
      .replaceFirst('Dr.', '')
      .trim()
      .split(' ')
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w[0])
      .join();
}

const loremDetails =
    'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate '
    'libero et velit interdum, ac aliquet odio mattis. Class aptent taciti '
    'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
    'Curabitur tempus urna at turpis condimentum lobortis. Ut commodo '
    'efficitur neque. Ut diam quam, semper iaculis condimentum ac, vestibulum '
    'eu nisl.';

// Date statice — aplicația nu are încă un backend.
const upcomingDoctor = Doctor(
  name: 'Dr. Richar Kandowen',
  specialty: 'Child Specialist',
  address: '24 Harbor Lane - 1.1KM from you',
  fee: 90,
);

const nearbyDoctors = [
  Doctor(
    name: 'Dr. Emmly Lestiryno',
    specialty: 'General Practitioner',
    address: '3167 Durgan Shores - 500M from you',
    fee: 80,
  ),
  Doctor(
    name: 'Dr. Sonja Littel',
    specialty: 'Dental Specialist',
    address: '950 Sigrid Port - 753M from you',
    fee: 100,
  ),
  Doctor(
    name: 'Dr.Upul',
    specialty: 'Denteeth',
    address: '12 Galle Road - 1.4KM from you',
    fee: 120,
  ),
];
