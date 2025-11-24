import 'package:flutter/material.dart';
import 'package:pos_app/screens/home_screen.dart';
import 'package:pos_app/services/update_service.dart'; // Pastikan file ini berisi class AppUpdater

void main() {
  runApp(const PosApp());
}

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rifan App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreenWrapper(),
    );
  }
}

// Wrapper untuk melakukan pengecekan update
class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  State<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  bool _checkedUpdate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pastikan checkUpdate hanya berjalan sekali
    if (!_checkedUpdate) {
      _checkedUpdate = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppUpdater.checkUpdate(context); // UBAH INI
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
