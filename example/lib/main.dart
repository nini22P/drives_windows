import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
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
  final _drivesWindowsPlugin = DrivesWindows();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    List<Drive> drives;
    List<NetworkShortcut> networkShortcuts;

    try {
      drives = await _drivesWindowsPlugin.getDrives();
    } on PlatformException {
      drives = [];
    }

    try {
      networkShortcuts = await _drivesWindowsPlugin.getNetworkShortcuts();
    } on PlatformException {
      networkShortcuts = [];
    }

    if (!mounted) return;

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
