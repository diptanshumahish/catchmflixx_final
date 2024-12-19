import 'package:catchmflixx/api/version/version_check.dart';
import 'package:catchmflixx/constants/text.dart';
import 'package:catchmflixx/models/version/version.model.dart';

Future<bool> isVersionUpToDate() async {
  VersionManager v = VersionManager();
  VersionInfo data = await v.checkVersion();
  const check = ConstantTexts.versionCheck;
  final dataVersion = data.data?.version?.toInt() ?? 0;

  if (check < dataVersion) {
    return false;
  }
  return true;
}
