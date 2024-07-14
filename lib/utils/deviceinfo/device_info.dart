import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> returnDeviceInfo() async {
  bool isIOS = Platform.isIOS;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  } else {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return "${androidInfo.brand} ${androidInfo.model}";
  }
}
