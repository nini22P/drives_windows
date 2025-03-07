import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:drives_windows/drives_windows.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:win32/win32.dart';

List<NetworkShortcut> getNetworkShortcuts() {
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

      String? path;
      String? description;

      final shellLink = ShellLink.createInstance();
      final persistFile = IPersistFile.from(shellLink);

      final lpPath = wsalloc(MAX_PATH + 1);
      final lpDescription = wsalloc(MAX_PATH + 1);

      if (persistFile.load(file.path.toNativeUtf16(), 0) == 0) {
        if (shellLink.getPath(lpPath, MAX_PATH + 1, nullptr, MAX_PATH + 1) ==
            0) {
          path = lpPath.toDartString().isEmpty ? null : lpPath.toDartString();
        }

        if (shellLink.getDescription(lpDescription, MAX_PATH + 1) == 0) {
          description =
              lpDescription.toDartString().isEmpty
                  ? null
                  : lpDescription.toDartString();
        }
      }

      networkShortcuts.add(
        NetworkShortcut(
          name: dir.path.split('\\').last,
          path: path,
          description: description,
        ),
      );

      free(lpPath);
      free(lpDescription);
    } catch (e) {
      if (kDebugMode) {
        log('Not get network shortcut target ${dir.path}: $e');
      }
    }
  }

  return networkShortcuts;
}
