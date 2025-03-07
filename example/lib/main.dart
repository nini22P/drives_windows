import 'package:drives_windows/drives.dart';
import 'package:drives_windows/network_shortcuts.dart';
import 'package:flutter/material.dart';
import 'package:drives_windows/drives_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Drive> _drives = [];
  List<NetworkShortcut> _networkShortcuts = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    final drives = getDrives();
    final networkShortcuts = getNetworkShortcuts();

    setState(() {
      _drives = drives;
      _networkShortcuts = networkShortcuts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Drives:', style: Theme.of(context).textTheme.headlineSmall),
              ..._drives.map((drive) => Text(drive.toString())),
              Text(
                'Network Shortcuts:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ..._networkShortcuts.map((shortcut) => Text(shortcut.toString())),
            ],
          ),
        ),
      ),
    );
  }
}
