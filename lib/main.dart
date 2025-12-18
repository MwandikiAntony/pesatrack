import 'package:flutter/material.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(const PesaTrackApp());
}

class PesaTrackApp extends StatelessWidget {
  const PesaTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PesaTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const MainLayout(),
    );
  }
}
