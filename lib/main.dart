import 'package:flutter/material.dart';
import 'package:testedropdrag/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desenvolvendo com Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const Home(title: 'Desenvolvendo um widget de upload com Flutter by Suami Rocha 🩵'),
    );
  }
}
