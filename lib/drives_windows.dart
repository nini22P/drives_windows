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

enum DriveType {
  unknown(0),
  noRootDirectory(1),
  removable(2),
  fixed(3),
  network(4),
  cdRom(5),
  ram(6);

  final int value;
  const DriveType(this.value);

  static DriveType fromValue(int value) {
    return values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }
}

class Drive {
  final String name;
  final DriveType type;
  final String format;
  final bool isReady;
  final double total;
  final double used;
  final double free;
  final String root;
  final String? volumeLabel;

  Drive({
    required this.name,
    required this.type,
    required this.format,
    required this.isReady,
    required this.total,
    required this.used,
    required this.free,
    required this.root,
    this.volumeLabel,
  });

  @override
  String toString() {
    return 'Drive{name: $name, type: $type, format: $format, isReady: $isReady, total: $total, used: $used, free: $free, root: $root, volumeLabel: $volumeLabel}';
  }
}

class NetworkShortcut {
  final String name;
  final String root;

  NetworkShortcut({required this.name, required this.root});

  @override
  String toString() {
    return 'NetworkShortcut{name: $name, root: $root}';
  }
}
