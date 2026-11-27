# Flutter Labs

Mobile application programming labs, built with Flutter in Android Studio.

| Lab | Folder | Description |
|-----|--------|-------------|
| 1 | [lab1_imc](lab1_imc/) | BMI (IMC) calculator |
| 2 | [lab2_appointment](lab2_appointment/) | Doctor appointment app (Figma V2) |
| 3 | [lab3_appointment](lab3_appointment/) | Lab 2 app with Cubit state management and async JSON loading |
| 4 | [lab4_appointment](lab4_appointment/) | Lab 3 app with REST services, JSON serialization and Clean Architecture |

## Running a lab

Open a lab folder in Android Studio (File → Open → `lab1_imc`, `lab2_appointment`, `lab3_appointment` or `lab4_appointment`), or from a terminal:

```bash
cd lab1_imc
flutter pub get
flutter run
```

Labs 3 and 4 also have a web platform, so they can run in a browser with `flutter run -d chrome` (lab 4 needs its local proxy there, see its README).

Each lab also has its own branch: `lab1`, `lab2`, `lab3`, `lab4`.
