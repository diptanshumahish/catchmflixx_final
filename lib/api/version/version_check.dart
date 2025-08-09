import 'dart:math' as Math;

import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/version/version.model.dart';
import 'package:catchmflixx/utils/toast.dart';

class VersionManager {
  final NetworkManager networkManager = NetworkManager();

  /// Checks the application version against the server
  /// 
  /// Returns [VersionInfo] if successful, null if there was an error
  /// Handles errors internally and shows appropriate messages to the user
  Future<VersionInfo?> checkVersion() async {
    try {
      final result = await networkManager.makeRequest<VersionInfo>(
        "admin/version/",
        (data) => VersionInfo.fromJson(data),
      );
      if (result == null) {
        ToastShow.returnToast("Unable to check for updates. Please try again later.");
      }
      
      return result;
    } catch (e) {
      ToastShow.returnToast("Version check failed: ${e.toString().substring(0, Math.min(100, e.toString().length))}");
            print("VersionManager error: $e");
      
      return null;
    }
  }
  
  /// Checks version and returns a boolean indicating if an update is required
  /// 
  /// This provides a simpler API for components that only need to know if an update is needed
  Future<bool> isUpdateRequired(String currentVersion) async {
    try {
      final versionInfo = await checkVersion();
      
      if (versionInfo == null) {
        return false;
      }
      final serverVersion = versionInfo.data?.version.toString()?? "0";
      final currentVersionNum = int.tryParse(currentVersion) ?? 0;
      final serverVersionNum = int.tryParse(serverVersion) ?? 0;
      
      return serverVersionNum > currentVersionNum;
    } catch (e) {
      print("Update check error: $e");
      return false;
    }
  }
}