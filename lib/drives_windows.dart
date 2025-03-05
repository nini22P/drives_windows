import 'package:drives_windows/drives.dart';
import 'package:drives_windows/network_shortcuts.dart';

class DrivesWindows {
  Future<List<Drive>> getDrives() async {
    return await Drives.getDrives();
  }

  Future<List<NetworkShortcut>> getNetworkShortcuts() async {
    return await NetworkShortcuts.getNetworkShortcuts();
  }
}

class Drive {
  final String name;
  final String root;
  final double used;
  final double free;
  final String? currentLocation;

  Drive({
    required this.name,
    required this.root,
    required this.used,
    required this.free,
    this.currentLocation,
  });

  @override
  String toString() {
    return 'name: $name, root: $root, used: $used, free: $free, currentLocation: $currentLocation';
  }
}

class NetworkShortcut {
  final String name;
  final String root;

  NetworkShortcut({required this.name, required this.root});

  @override
  String toString() {
    return 'name: $name, root: $root';
  }
}
