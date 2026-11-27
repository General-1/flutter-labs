import 'package:flutter/material.dart';

void main() {
  runApp(const ImcApp());
}

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ImcPage(),
    );
  }
}

/// Calculează IMC = greutate (kg) / înălțime (m)².
double calculeazaImc(double greutateKg, double inaltimeCm) {
  final inaltimeM = inaltimeCm / 100;
  return greutateKg / (inaltimeM * inaltimeM);
}

/// Categoria IMC conform clasificării OMS.
String categorieImc(double imc) {
  if (imc < 18.5) return 'Subponderal';
  if (imc < 25) return 'Greutate normală';
  if (imc < 30) return 'Supraponderal';
  if (imc < 35) return 'Obezitate gradul I';
  if (imc < 40) return 'Obezitate gradul II';
  return 'Obezitate gradul III';
}

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  final _greutateController = TextEditingController();
  final _inaltimeController = TextEditingController();

  String _rezultat = '';
  String _categorie = '';
  bool _eroare = false;

  @override
  void dispose() {
    _greutateController.dispose();
    _inaltimeController.dispose();
    super.dispose();
  }

  // Acceptă atât "70.5" cât și "70,5".
  double? _citesteNumar(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));

  // Evenimentul onPressed al butonului „Calculează”.
  void _calculeaza() {
    FocusScope.of(context).unfocus(); // ascunde tastatura

    final greutate = _citesteNumar(_greutateController.text);
    final inaltime = _citesteNumar(_inaltimeController.text);

    setState(() {
      if (greutate == null || inaltime == null) {
        _eroare = true;
        _rezultat = 'Introduceți valori numerice valide.';
        _categorie = '';
      } else if (greutate <= 0 || inaltime <= 0) {
        _eroare = true;
        _rezultat = 'Greutatea și înălțimea trebuie să fie pozitive.';
        _categorie = '';
      } else {
        final imc = calculeazaImc(greutate, inaltime);
        _eroare = false;
        _rezultat = 'IMC: ${imc.toStringAsFixed(1)}';
        _categorie = 'Categoria: ${categorieImc(imc)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator IMC'),
        backgroundColor: scheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _greutateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Greutate',
                suffixText: 'kg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inaltimeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Înălțime',
                suffixText: 'cm',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _calculeaza(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculeaza,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Calculează', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 32),
            Text(
              _rezultat,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _eroare ? 16 : 28,
                fontWeight: FontWeight.bold,
                color: _eroare ? scheme.error : scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _categorie,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: scheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
