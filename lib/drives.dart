import 'dart:developer';
import 'dart:io';
import 'package:drives_windows/drives_windows.dart';
import 'package:flutter/foundation.dart';

class Drives {
  static Future<List<Drive>> getDrives() async {
    ProcessResult result = await Process.run('powershell', [
      '-Command',
      'Get-PSDrive -PSProvider FileSystem',
    ]);

    if (result.exitCode != 0) {
      if (kDebugMode) {
        log('Error: ${result.stderr}');
      }
      return [];
    }

    String output = result.stdout;
    return _parseOutput(output);
  }

  static List<Drive> _parseOutput(String output) {
    List<Drive> drives = [];
    List<String> lines = output.split('\n');

    for (var line in lines.skip(3)) {
      if (line.trim().isEmpty) continue;

      RegExp regExp = RegExp(r'(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.+?)\s+(.+)');
      Match? match = regExp.firstMatch(line);

      if (match != null) {
        String name = match.group(1) ?? '';
        double used = double.tryParse(match.group(2) ?? '0') ?? 0;
        double free = double.tryParse(match.group(3) ?? '0') ?? 0;
        String root = match.group(5) ?? '';
        String currentLocation = match.group(6) ?? '';

        drives.add(
          Drive(
            name: name,
            root: root,
            used: used,
            free: free,
            currentLocation:
                currentLocation.isNotEmpty ? currentLocation : null,
          ),
        );
      }
    }

    return drives;
  }
}
