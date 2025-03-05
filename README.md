# Drives Windows

A Flutter plugin get drives and network shortcuts for Windows

## How to use

```dart
import 'package:drives_windows/drives_windows.dart';

final drivesWindows = DrivesWindows();

final drives = await drivesWindows.getDrives();
final networkShortcuts = await drivesWindows.getNetworkShortcuts();

```


