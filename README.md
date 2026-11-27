# Flutter Labs

Mobile application programming labs, built with Flutter in Android Studio.

| Lab | Folder | Description |
|-----|--------|-------------|
| 1 | [lab1_imc](lab1_imc/) | BMI (IMC) calculator |
| 2 | [lab2_appointment](lab2_appointment/) | Doctor appointment app (Figma V2) |
| 3 | [lab3_appointment](lab3_appointment/) | Lab 2 app with Cubit state management and async JSON loading |

## Running a lab

Open a lab folder in Android Studio (File → Open → `lab1_imc`, `lab2_appointment` or `lab3_appointment`), or from a terminal:

```bash
cd lab1_imc
flutter pub get
flutter run
```

Lab 3 also has a web platform, so it can run in a browser with `flutter run -d chrome`.
