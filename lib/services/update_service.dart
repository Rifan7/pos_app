import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AppUpdater {
  static const String versionUrl =
      "https://raw.githubusercontent.com/Rifan7/pos_app/main/version.json";

  static Future<void> checkUpdate(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(versionUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final latestVersion = data["version"];
        final changelog = data["changelog"] ?? "";
        final apkUrl = data["apk_url"];

        const String currentVersion = "1.0.0"; // versi aplikasi di HP

        if (latestVersion != currentVersion) {
          _showUpdateDialog(context, latestVersion, changelog, apkUrl);
        }
      }
    } catch (e) {
      print("Update check error: $e");
    }
  }

  static void _showUpdateDialog(
      BuildContext context, String latest, String log, String apkUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Update Tersedia"),
          content: Text(
              "Versi terbaru: $latest\n\nCatatan perubahan:\n$log\n"),
          actions: [
            TextButton(
              onPressed: () async {
                await launchUrl(Uri.parse(apkUrl),
                    mode: LaunchMode.externalApplication);
              },
              child: const Text("UPDATE"),
            ),
          ],
        );
      },
    );
  }
}
