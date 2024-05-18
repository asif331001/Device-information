import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
  }

  Future<void> _initDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceType;
    String deviceUniqueId;
    String deviceName;
    String deviceModel;
    String deviceManufacturer;

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceType = 'Android';
        deviceUniqueId = androidInfo.id ?? 'Unknown';
        deviceName = androidInfo.model ?? 'Unknown';
        deviceModel = androidInfo.device ?? 'Unknown';
        deviceManufacturer = androidInfo.manufacturer ?? 'Unknown';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceType = 'iOS';
        deviceUniqueId = iosInfo.identifierForVendor ?? 'Unknown';
        deviceName = iosInfo.name ?? 'Unknown';
        deviceModel = iosInfo.model ?? 'Unknown';
        deviceManufacturer = 'Apple';
      } else if (Platform.isMacOS) {
        final MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
        deviceType = 'macOS';
        deviceUniqueId = macInfo.systemGUID ?? 'Unknown';
        deviceName = macInfo.model ?? 'Unknown';
        deviceModel = macInfo.model ?? 'Unknown';
        deviceManufacturer = 'Apple';
      } else if (Platform.isWindows) {
        final WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceType = 'Windows';
        deviceUniqueId = windowsInfo.deviceId ?? 'Unknown';
        deviceName = windowsInfo.computerName ?? 'Unknown';
        deviceModel = 'Unknown'; // Windows devices don't have a specific model
        deviceManufacturer = 'Unknown'; // Windows devices don't have a specific manufacturer
      } else if (Platform.isLinux) {
        final LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceType = 'Linux';
        deviceUniqueId = linuxInfo.machineId ?? 'Unknown';
        deviceName = linuxInfo.name ?? 'Unknown';
        deviceModel = linuxInfo.name ?? 'Unknown';
        deviceManufacturer = 'Unknown'; // Linux devices typically don't have a specific manufacturer
      } else if (kIsWeb) {
        final WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        deviceType = 'Web';
        deviceUniqueId = '${webInfo.vendor ?? 'Unknown'} ${webInfo.userAgent ?? 'Unknown'}';
        deviceName = webInfo.browserName.name ?? 'Unknown';
        deviceModel = 'Unknown'; // Web devices don't have a specific model
        deviceManufacturer = webInfo.vendor ?? 'Unknown';
      } else {
        deviceType = 'Unknown';
        deviceUniqueId = 'Unknown';
        deviceName = 'Unknown';
        deviceModel = 'Unknown';
        deviceManufacturer = 'Unknown';
      }
    } catch (e) {
      deviceType = 'Error';
      deviceUniqueId = 'Error';
      deviceName = 'Error';
      deviceModel = 'Error';
      deviceManufacturer = 'Error';
    }

    setState(() {
      this.deviceType = deviceType;
      this.deviceUniqueId = deviceUniqueId;
      this.deviceName = deviceName;
      this.deviceModel = deviceModel;
      this.deviceManufacturer = deviceManufacturer;
    });
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
            SizedBox(height: 8),
            Text('Device Model: $deviceModel'),
            SizedBox(height: 8),
            Text('Device Manufacturer: $deviceManufacturer'),
          ],
        ),
      ),
    );
  }
}



