import 'package:flutter/material.dart';
import 'package:pos_app/screens/home_screen.dart';

void main() {
  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Opsional: tambah font Poppins ke pubspec.yaml
      ),
      home: const HomeScreen(),
    );
  }
}