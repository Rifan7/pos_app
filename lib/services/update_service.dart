import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdater {
  static const String versionUrl =
      "https://raw.githubusercontent.com/Rifan7/pos_app/main/version.json";

  static Future<void> checkUpdate(BuildContext context) async {
    try {
      PackageInfo info = await PackageInfo.fromPlatform();
      String currentVersion = info.version;

      final response = await http.get(Uri.parse(versionUrl));
      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);
      String latestVersion = data["version"];
      String changelog = data["changelog"];
      String apkUrl = data["apk_url"];

      if (latestVersion != currentVersion) {
        _showUpdateDialog(context, latestVersion, changelog, apkUrl);
      }
    } catch (e) {
      print("Gagal cek update: $e");
    }
  }

  static void _showUpdateDialog(
      BuildContext context,
      String version,
      String changelog,
      String apkUrl,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Update $version tersedia"),
          content: Text("Catatan perubahan:\n$changelog"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Nanti"),
            ),
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(apkUrl), mode: LaunchMode.externalApplication);
              },
              child: Text("Update Sekarang"),
            ),
          ],
        );
      },
    );
  }
}
