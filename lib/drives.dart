import 'dart:ffi';
import 'dart:io';
import 'package:drives_windows/drives_windows.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

List<Drive> getDrives() {
  if (!Platform.isWindows) return [];

  List<Drive> drives = [];
  int bitmask = GetLogicalDrives() & 0xFFFFFFFF;

  for (int i = 0; i < 26; i++) {
    if (bitmask & (1 << i) != 0) {
      String driveLetter = String.fromCharCode('A'.codeUnitAt(0) + i);
      String rootPath = '$driveLetter:\\';
      final lpRootName = rootPath.toNativeUtf16();

      int driveType = GetDriveType(lpRootName);

      final lpVolumeName = wsalloc(MAX_PATH + 1);
      final lpFileSystemName = wsalloc(MAX_PATH + 1);

      if (GetVolumeInformation(
            lpRootName,
            lpVolumeName,
            MAX_PATH + 1,
            nullptr,
            nullptr,
            nullptr,
            lpFileSystemName,
            MAX_PATH + 1,
          ) !=
          NULL) {
        String volumeName = lpVolumeName.toDartString();
        String fileSystemName = lpFileSystemName.toDartString();

        final lpFreeBytesAvailable = calloc<Uint64>();
        final lpTotalBytes = calloc<Uint64>();
        final lpTotalFreeBytes = calloc<Uint64>();

        if (GetDiskFreeSpaceEx(
              lpRootName,
              lpFreeBytesAvailable,
              lpTotalBytes,
              lpTotalFreeBytes,
            ) !=
            NULL) {
          int freeBytesAvailable = lpFreeBytesAvailable.value;
          int totalBytes = lpTotalBytes.value;
          int usedBytes = totalBytes - freeBytesAvailable;

          double totalGB = totalBytes / (1024 * 1024 * 1024);
          double usedGB = usedBytes / (1024 * 1024 * 1024);
          double freeGB = freeBytesAvailable / (1024 * 1024 * 1024);

          DriveType type = DriveType.fromValue(driveType);

          drives.add(
            Drive(
              name: '$driveLetter:',
              type: type,
              format: fileSystemName,
              total: double.parse(totalGB.toStringAsFixed(2)),
              used: double.parse(usedGB.toStringAsFixed(2)),
              free: double.parse(freeGB.toStringAsFixed(2)),
              root: rootPath,
              volumeLabel: volumeName.isEmpty ? null : volumeName,
            ),
          );
        }

        free(lpFreeBytesAvailable);
        free(lpTotalBytes);
        free(lpTotalFreeBytes);
      }

      free(lpRootName);
      free(lpVolumeName);
      free(lpFileSystemName);
    }
  }

  return drives;
}
