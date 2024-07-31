import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/payments/phonepe_init.model.dart';
import 'package:catchmflixx/models/payments/renting_options.model.dart';
import 'package:dio/dio.dart';

class PaymentsManager {
  final NetworkManager networkManager = NetworkManager();
  String path = "payment";

  Future<RentingOptions> getMovieRents(String search) async {
    return await networkManager.makeRequest<RentingOptions>(
      "$path/movie-rents/$search",
      (data) => RentingOptions.fromJson(data),
    );
  }

  Future<PhonePeInit> phonePeInitMovie(String search) async {
    return await networkManager.makeRequest<PhonePeInit>(
        "$path/rent/movie", (data) => PhonePeInit.fromJson(data),
        data: FormData.fromMap({"id": search}), method: "POST");
  }
}