import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdater {
  static Future<void> checkUpdate(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse("https://raw.githubusercontent.com/Rifan7/pos_app/main/version.json"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String latestVersion = data["version"];
        String changelog = data["changelog"];
        String apkUrl = data["apk_url"];

        PackageInfo info = await PackageInfo.fromPlatform();
        String currentVersion = info.version;

        if (latestVersion != currentVersion) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Update Tersedia"),
              content: Text(
                "Versi terbaru: $latestVersion\n"
                "Versi kamu: $currentVersion\n\n"
                "Catatan Perubahan:\n$changelog",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Nanti"),
                ),
                TextButton(
                  onPressed: () => launchUrl(Uri.parse(apkUrl)),
                  child: const Text("Update"),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print("Error checking update: $e");
    }
  }
}
