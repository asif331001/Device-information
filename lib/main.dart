import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:android_id/android_id.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DeviceInfoScreen(),
    );
  }
}

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  String deviceType = '';
  String deviceUniqueId = '';
  String deviceName = '';
  String deviceModel = '';
  String deviceManufacturer = '';
  static const _androidIdPlugin = AndroidId();
  String _androidId = 'Unknown';

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
    _initAndroidId();
  }

  Future<void> _initDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceType = 'Android';
          deviceUniqueId = androidInfo.id ?? 'Unknown';
          deviceName = androidInfo.brand ?? 'Unknown';
          deviceModel = androidInfo.model ?? 'Unknown';
          deviceManufacturer = androidInfo.manufacturer ?? 'Unknown';
        });
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceType = 'iOS';
          deviceUniqueId = iosInfo.identifierForVendor ?? 'Unknown';
          deviceName = iosInfo.name ?? 'Unknown';
          deviceModel = iosInfo.model ?? 'Unknown';
          deviceManufacturer = 'Apple';
        });
      } else if (Platform.isMacOS) {
        final MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
        setState(() {
          deviceType = 'macOS';
          deviceUniqueId = macInfo.systemGUID ?? 'Unknown';
          deviceName = macInfo.model ?? 'Unknown';
          deviceModel = macInfo.model ?? 'Unknown';
          deviceManufacturer = 'Apple';
        });
      } else if (Platform.isWindows) {
        final WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
        setState(() {
          deviceType = 'Windows';
          deviceUniqueId = windowsInfo.deviceId ?? 'Unknown';
          deviceName = windowsInfo.computerName ?? 'Unknown';
          deviceModel = 'Unknown';
          deviceManufacturer = 'Unknown';
        });
      } else if (Platform.isLinux) {
        final LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
        setState(() {
          deviceType = 'Linux';
          deviceUniqueId = linuxInfo.machineId ?? 'Unknown';
          deviceName = linuxInfo.name ?? 'Unknown';
          deviceModel = linuxInfo.name ?? 'Unknown';
          deviceManufacturer = 'Unknown';
        });
      } else {
        setState(() {
          deviceType = 'Unknown';
          deviceUniqueId = 'Unknown';
          deviceName = 'Unknown';
          deviceModel = 'Unknown';
          deviceManufacturer = 'Unknown';
        });
      }
    } catch (e) {
      setState(() {
        deviceType = 'Error';
        deviceUniqueId = 'Error';
        deviceName = 'Error';
        deviceModel = 'Error';
        deviceManufacturer = 'Error';
      });
    }
  }

  Future<void> _initAndroidId() async {
    try {
      final androidId = await _androidIdPlugin.getId() ?? 'Unknown ID';
      if (mounted) {
        setState(() {
          _androidId = androidId;
        });
      }
    } on PlatformException {
      if (mounted) {
        setState(() {
          _androidId = 'Failed to get Android ID.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Type: $deviceType'),
            const SizedBox(height: 8),
            Text('Device Unique ID: $deviceUniqueId'),
            const SizedBox(height: 8),
            Text('Device Name: $deviceName'),
            const SizedBox(height: 8),
            Text('Device Model: $deviceModel'),
            const SizedBox(height: 8),
            if (Platform.isAndroid) Text('Android Device ID: $_androidId'),
            const SizedBox(height: 8),
            Text('Device Manufacturer: $deviceManufacturer'),
          ],
        ),
      ),
    );
  }
}
