# Drives Windows

A Flutter plugin get drives and network shortcuts on Windows.

## How to use

* Add `drives_windows` on your pubspec.yaml dependencies

```yaml
  drives_windows:
    git:
      url: https://github.com/nini22P/drives_windows
      ref: main
```

* Upgrade `drives_windows`

```shell
flutter pub upgrade drives_windows
```

### Example

```dart
import 'package:drives_windows/drives_windows.dart';

final drivesWindows = DrivesWindows();

final drives = drivesWindows.getDrives();
final networkShortcuts = drivesWindows.getNetworkShortcuts();

```

or

```dart
import 'package:drives_windows/drives.dart';
import 'package:drives_windows/network_shortcuts.dart';

final drives = getDrives();
final networkShortcuts = getNetworkShortcuts();
```
