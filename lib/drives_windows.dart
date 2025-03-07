import 'package:drives_windows/drives.dart' as drives;
import 'package:drives_windows/network_shortcuts.dart' as network_shortcuts;

class DrivesWindows {
  List<Drive> getDrives() => drives.getDrives();

  List<NetworkShortcut> getNetworkShortcuts() =>
      network_shortcuts.getNetworkShortcuts();
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
  final double total;
  final double used;
  final double free;
  final String root;
  final String? volumeLabel;

  Drive({
    required this.name,
    required this.type,
    required this.format,
    required this.total,
    required this.used,
    required this.free,
    required this.root,
    this.volumeLabel,
  });

  @override
  String toString() {
    return 'Drive: {name: $name, type: $type, format: $format, total: $total, used: $used, free: $free, root: $root, volumeLabel: $volumeLabel}';
  }
}

class NetworkShortcut {
  final String name;
  final String? path;
  final String? description;

  NetworkShortcut({required this.name, this.path, this.description});

  @override
  String toString() {
    return 'NetworkShortcut: {name: $name, path: $path, description: $description}';
  }
}
