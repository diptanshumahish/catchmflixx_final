import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/ads/ads.response.model.dart';

class AdsManager {
  final NetworkManager networkManager = NetworkManager();
  String path = "content";

  Future<AdsResponse> getAds() async {
    return await networkManager.makeRequest<AdsResponse>(
      "$path/banner-retrieve",
      (data) => AdsResponse.fromJson(data),
    );
  }
}
