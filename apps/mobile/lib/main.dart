import 'package:flutter/material.dart';

void main() {
  runApp(const SubwayPushApp());
}

class SubwayPushApp extends StatelessWidget {
  const SubwayPushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subway Push',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B7A75)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subway Push')),
      body: const Center(
        child: Text('API and mobile workspace are ready.'),
      ),
    );
  }
}
