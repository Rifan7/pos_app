import 'dart:convert'; // <-- Baris ini yang ditambahkan
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:version/version.dart';

class UpdateService {
  // Ganti dengan informasi repository Anda
  static const String _repoOwner = 'Rifan7';
  static const String _repoName = 'pos_app';

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      // 1. Dapatkan versi aplikasi yang terinstall
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(packageInfo.version);

      // 2. Ambil data release terbaru dari GitHub API
      final url = Uri.parse(
        'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final release = json.decode(response.body);
        final latestVersionString = release['tag_name'].toString().substring(
              1,
            ); // Hilangkan 'v'
        final latestVersion = Version.parse(latestVersionString);
        final downloadUrl = release['assets'][0]['browser_download_url'];
        final apkName = release['assets'][0]['name'];

        // 3. Bandingkan versi
        if (latestVersion > currentVersion) {
          // 4. Jika ada versi baru, tampilkan dialog
          _showUpdateDialog(context, latestVersionString, downloadUrl, apkName);
        }
      } else {
        // Handle error
        debugPrint('Gagal mengecek versi: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error saat mengecek update: $e');
    }
  }

  static void _showUpdateDialog(
    BuildContext context,
    String newVersion,
    String downloadUrl,
    String apkName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan klik di luar
      builder: (ctx) => AlertDialog(
        title: const Text('Pembaruan Tersedia!'),
        content: Text(
          'Versi terbaru ($newVersion) sudah tersedia. Silakan perbarui aplikasi Anda.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Nanti Saja'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _downloadAndInstall(context, downloadUrl, apkName);
            },
            child: const Text('Perbarui Sekarang'),
          ),
        ],
      ),
    );
  }

  static Future<void> _downloadAndInstall(
    BuildContext context,
    String url,
    String fileName,
  ) async {
    // Tampilkan indikator progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Mengunduh..."),
          ],
        ),
      ),
    );

    try {
      final directory = await getExternalStorageDirectory();
      final path = '${directory?.path}/$fileName';
      final response = await http.get(Uri.parse(url));

      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);

      Navigator.of(context).pop(); // Tutup dialog "Mengunduh"

      // Trigger proses instalasi
      _installApk(path);
    } catch (e) {
      Navigator.of(context).pop(); // Tutup dialog "Mengunduh"
      debugPrint('Error saat mengunduh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunduh pembaruan.')),
      );
    }
  }

  static void _installApk(String filePath) {
    // Untuk Android, kita menggunakan Intent untuk membuka file APK
    // Implementasi ini memerlukan plugin atau platform channel yang lebih kompleks.
    // Sebagai solusi sederhana, kita bisa buka file tersebut dan biarkan sistem Android menanganinya.
    // Namun, cara terbaik adalah menggunakan `install_plugin` atau membuat `MethodChannel`.
    // Berikut adalah contoh sederhana yang mungkin tidak bekerja di semua versi Android.
    // Untuk solusi yang lebih robust, pertimbangkan untuk menggunakan `install_plugin`.
    debugPrint('APK tersimpan di: $filePath. Silakan install secara manual.');
    // Tambahkan notifikasi ke user bahwa file sudah diunduh
    // dan mereka perlu membukanya dari folder Downloads atau menggunakan file manager.
  }
}
