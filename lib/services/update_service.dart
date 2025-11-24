import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AppUpdater {
  static const String versionUrl =
      "https://raw.githubusercontent.com/Rifan7/pos_app/main/version.json";

  // versi aplikasi SEKARANG → kamu ubah manual saat build APK
  static const String currentVersion = "1.0.0";

  static Future<void> checkUpdate(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(versionUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data["version"];
        final apkUrl = data["apk_url"];

        if (latestVersion != currentVersion) {
          _showUpdateDialog(context, latestVersion, apkUrl);
        }
      }
    } catch (e) {
      print("Gagal cek update: $e");
    }
  }

  static void _showUpdateDialog(
      BuildContext context, String latestVersion, String apkUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.system_update, size: 28),
              SizedBox(width: 10),
              Text("Update Tersedia"),
            ],
          ),
          content: Text(
            "Versi baru tersedia: $latestVersion\n\n"
            "Silakan update sekarang.",
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse(apkUrl),
                    mode: LaunchMode.externalApplication);
              },
              child: Text("Update Sekarang"),
            ),
          ],
        );
      },
    );
  }
}
