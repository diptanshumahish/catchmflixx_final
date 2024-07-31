import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/version/version.model.dart';

class VersionManager {
  final NetworkManager networkManager = NetworkManager();

  Future<VersionInfo> checkVersion() async {
    return await networkManager.makeRequest<VersionInfo>(
      "admin/version/",
      (data) => VersionInfo.fromJson(data),
    );
  }
}
