import 'package:flutter/material.dart';
import 'services/update_service.dart';   // pastikan ini sesuai nama file kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS App',
      home: UpdateWrapper(child: MyHomePage()),
    );
  }
}

// ===============================
// WRAPPER UNTUK CEK UPDATE OTOMATIS
// ===============================
class UpdateWrapper extends StatefulWidget {
  final Widget child;
  const UpdateWrapper({super.key, required this.child});

  @override
  State<UpdateWrapper> createState() => _UpdateWrapperState();
}

class _UpdateWrapperState extends State<UpdateWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdater.checkUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// ===============================
// HALAMAN UTAMA ANDA
// ===============================
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POS App"),
      ),
      body: Center(
        child: Text("Halaman Utama Aplikasi"),
      ),
    );
  }
}
