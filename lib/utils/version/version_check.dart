import 'package:catchmflixx/api/version/version_check.dart';
import 'package:catchmflixx/constants/text.dart';
import 'package:catchmflixx/models/version/version.model.dart';
import 'package:catchmflixx/utils/toast.dart';

/// Checks if the app version is up to date
/// 
/// Returns:
/// - true if the app is up to date
/// - false if an update is needed
/// - true if version check fails (to prevent blocking the app)
Future<bool> isVersionUpToDate() async {
  try {
    VersionManager versionManager = VersionManager();
    VersionInfo? versionInfo = await versionManager.checkVersion();
        if (versionInfo == null || versionInfo.data == null) {
      ToastShow.returnToast("Version check failed: Unable to get version information");
      return true;
    }
    
    const currentVersion = ConstantTexts.versionCheck;
    final serverVersion = versionInfo.data?.version?.toInt() ?? 0;
        return currentVersion >= serverVersion;
  } catch (e) {
    ToastShow.returnToast("Version check error: $e");
    return true;
  }
}