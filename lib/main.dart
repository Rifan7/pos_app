import 'package:flutter/material.dart';
import 'package:pos_app/screens/home_screen.dart';
import 'package:pos_app/services/update_service.dart';

void main() {
  runApp(const PosApp());
}

class PosApp extends StatefulWidget {
  const PosApp({super.key});

  @override
  State<PosApp> createState() => _PosAppState();
}

class _PosAppState extends State<PosApp> {
  @override
  void initState() {
    super.initState();
    // Jangan jalankan checkForUpdate di sini langsung,
    // karena `context` belum tersedia.
    // Kita akan menjalankannya dari widget pertama yang dibangun.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreenWrapper(),
    );
  }
}

// Widget wrapper untuk menjalankan pengecekan update
class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  State<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Jalankan pengecekan update saat widget pertama kali dibangun
    // dan context sudah tersedia.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
