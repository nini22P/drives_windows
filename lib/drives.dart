import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:drives_windows/drives_windows.dart';
import 'package:flutter/foundation.dart';

class Drives {
  static Future<List<Drive>> getDrives() async {
    ProcessResult result = await Process.run('powershell', [
      '-NoProfile',
      '-NoLogo',
      '-NonInteractive',
      '-Command',
      '[System.IO.DriveInfo]::GetDrives() | ConvertTo-Json',
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
    try {
      List<Drive> drives = [];
      List<Map<String, dynamic>> jsonList;

      final json = jsonDecode(output);
      if (json is List) {
        jsonList = json as List<Map<String, dynamic>>;
      } else {
        jsonList = [json as Map<String, dynamic>];
      }

      for (Map<String, dynamic> jsonDrive in jsonList) {
        Map<String, dynamic> driveMap = jsonDrive;
        String name = driveMap['Name'].substring(0, 2); // "C:"
        String root = driveMap['Name']; // "C:\\"
        int driveTypeNum = driveMap['DriveType'];
        DriveType driveType = DriveType.fromValue(driveTypeNum);
        String format = driveMap['DriveFormat'];
        bool isReady = driveMap['IsReady'];
        int totalSize = driveMap['TotalSize'];
        int availableFreeSpace = driveMap['AvailableFreeSpace'];
        double used = (totalSize - availableFreeSpace).toDouble();
        double free = availableFreeSpace.toDouble();

        // Convert sizes to GB
        double totalGB = totalSize / (1024 * 1024 * 1024);
        double usedGB = used / (1024 * 1024 * 1024);
        double freeGB = free / (1024 * 1024 * 1024);

        // Format to two decimal places
        double totalFormatted = _processSize(totalGB);
        double usedFormatted = _processSize(usedGB);
        double freeFormatted = _processSize(freeGB);

        String volumeLabel = driveMap['VolumeLabel'];

        drives.add(
          Drive(
            name: name,
            type: driveType,
            format: format,
            isReady: isReady,
            total: totalFormatted,
            used: usedFormatted,
            free: freeFormatted,
            root: root,
            volumeLabel: volumeLabel.isEmpty ? null : volumeLabel,
          ),
        );
      }
      return drives;
    } catch (e) {
      if (kDebugMode) {
        log('Error parsing JSON: $e');
      }
      return [];
    }
  }

  static double _processSize(double size) =>
      double.parse(size.toStringAsFixed(2));
}
