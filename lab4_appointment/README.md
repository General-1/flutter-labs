# lab4_appointment

Laborator 4 — aplicația Doctor Appointment (Figma V2) cu **servicii REST**,
**JSON Serialization** și **Clean Architecture**. Designul și stările sunt cele
din laboratorul 3; datele vin acum de la server.

## Serviciile Web

| Cerere | Serviciu | La ce folosește |
|---|---|---|
| `GET /feed` | `test-api-jlbn.onrender.com/lab2026/v2` | Homescreen |
| `GET /feed/details` | același | ecranul de detalii |
| `POST /posts` | `jsonplaceholder.typicode.com` | trimiterea programării |

API-ul variantei 2 acceptă doar citire (un `POST` primește 404), de aceea
programarea se trimite la un al doilea serviciu. Acesta este un server public
de test: răspunde cu un număr de referință, dar **nu salvează nimic**. Se
trimit doar numele doctorului, ziua și ora.

## Rulare

Pe Android sau Windows:

```bash
flutter pub get
flutter run
```

În browser este nevoie de proxy-ul local, pentru că serverul de date nu trimite
antetele CORS. Într-un terminal:

```bash
dart run tool/dev_proxy.dart
```

În alt terminal:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8787/lab2026/v2
```

Verificare:

```bash
flutter analyze
flutter test
```

După o modificare în `lib/data/models/`, codul JSON se generează din nou:

```bash
dart run build_runner build
```

## Structura (Clean Architecture)

```
lib/
  main.dart            leagă straturile între ele
  core/
    error/             tipurile de erori (Failure)
    network/           clientul HTTP și adresele
  domain/              Dart curat: nu știe de HTTP, JSON sau Flutter
    entities/          obiectele aplicației
    repositories/      interfața AppointmentRepository
    usecases/          GetHomeFeed, GetAppointmentDetails, BookAppointment
  data/
    models/            clasele JSON (fromJson / toJson)
    datasources/       cererile către cele două servicii
    repositories/      implementarea interfeței din domain
  presentation/
    cubits/            logica și stările ecranelor
    screens/           Homescreen și detaliile
    widgets/           componente reutilizabile
    theme/             culorile
```

Dependențele merg spre interior: `presentation → domain ← data`.

## Fluxul datelor

### Citire (Homescreen)

1. `HomeScreen` afișează starea din `HomeCubit`, care pornește cu `load()` și
   emite `HomeLoading`.
2. `HomeCubit` apelează cazul de utilizare `GetHomeFeed`.
3. `GetHomeFeed` cere datele de la `AppointmentRepository` (interfața).
4. `AppointmentRepositoryImpl` apelează `AppointmentRemoteDataSource`.
5. `ApiClient` trimite `GET /feed`, verifică codul HTTP și decodează textul cu
   `jsonDecode`.
6. `HomeFeedModel.fromJson` creează modelul (deserializare), iar `toEntity()`
   îl transformă în `HomeFeed`.
7. Entitatea se întoarce la Cubit, care emite `HomeSuccess`; `BlocBuilder`
   redesenează ecranul.

```
Widget → Cubit → Use case → Repository → Data source → ApiClient → server
Widget ← State ← Entity   ← toEntity() ← fromJson     ← JSON     ← server
```

### Trimitere (Book an Appointment)

1. Butonul apelează `DetailsCubit.book()`, care emite `BookingSending`
   (indicator pe buton, fără al doilea tap).
2. `BookAppointment` → repository → `BookingRemoteDataSource`.
3. `BookingRequestModel.toJson()` (serializare) devine corpul cererii `POST`.
4. Răspunsul devine `BookingConfirmation`; Cubit-ul emite `BookingSent`
   (dialog) sau `BookingFailed` (mesaj, se poate reîncerca).

## Încărcare și erori

| Situație | Failure | Ce vede utilizatorul |
|---|---|---|
| fără internet | `NetworkFailure` | mesaj și „Try again” |
| peste 60 de secunde | `TimeoutFailure` | „The server took too long…” |
| cod HTTP diferit de 2xx | `ServerFailure` | codul erorii |
| JSON neașteptat | `ParsingFailure` | „…data the app could not read” |

Cât se încarcă apare un indicator, iar dacă lista de doctori este goală apare
starea Empty. Serverul gratuit adoarme, deci prima cerere poate dura.

## De știut

- `GET /feed/details` nu primește un `id`. Numele, specialitatea și poza sunt
  ale doctorului ales; plata, descrierea, orele și zilele sunt aceleași pentru
  toți. Doctorul din răspuns („Dr.Upul”) nu apare.
- Favoritele se păstrează doar cât aplicația este deschisă.
- Textele sunt afișate exact cum vin de la server.
- Testele nu folosesc internetul: răspunsurile reale sunt salvate în
  `test/fixtures/`, iar cererile HTTP sunt simulate cu `MockClient`.
