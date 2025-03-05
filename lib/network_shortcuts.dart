import 'dart:developer';
import 'dart:io';
import 'package:drives_windows/drives_windows.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class NetworkShortcuts {
  static Future<List<NetworkShortcut>> getNetworkShortcuts() async {
    String? currentUser = Platform.environment['USERNAME'];
    if (currentUser == null) {
      if (kDebugMode) {
        log('Not get current usernamr');
      }
      return [];
    }

    String networkShortcutsPath = p.join(
      'C:',
      'Users',
      currentUser,
      'AppData',
      'Roaming',
      'Microsoft',
      'Windows',
      'Network Shortcuts',
    );

    Directory shortcutsDir = Directory(networkShortcutsPath);
    if (!shortcutsDir.existsSync()) {
      if (kDebugMode) {
        log('Network shortcuts directory not found: $networkShortcutsPath');
      }
      return [];
    }

    List<NetworkShortcut> networkShortcuts = [];

    List<FileSystemEntity> dirs = shortcutsDir.listSync();

    for (var dir in dirs) {
      try {
        final File file = File('${dir.path}\\target.lnk');
        final String root = await _getShortcutTargetPath(file.path);
        networkShortcuts.add(
          NetworkShortcut(name: dir.path.split('\\').last, root: root),
        );
      } catch (e) {
        if (kDebugMode) {
          log('Not get network shortcut target ${dir.path}: $e');
        }
      }
    }

    return networkShortcuts;
  }

  static Future<String> _getShortcutTargetPath(String shortcutPath) async {
    String command = '''
    \$sh = New-Object -ComObject WScript.Shell; 
    \$target = \$sh.CreateShortcut('$shortcutPath').TargetPath; 
    \$target
  ''';

    ProcessResult result = await Process.run('powershell.exe', [
      '-Command',
      command,
    ]);

    if (result.exitCode != 0) {
      throw Exception('Error: ${result.stderr}');
    }

    return result.stdout.trim();
  }
}
