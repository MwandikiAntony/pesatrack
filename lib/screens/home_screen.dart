import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PesaTrack'), centerTitle: true),
      body: const Center(
        child: Text(
          'Your expenses will appear here',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
