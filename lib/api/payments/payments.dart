import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/payments/episode_phonepe_init.model.dart';
import 'package:catchmflixx/models/payments/episode_rent_options.dart';
import 'package:catchmflixx/models/payments/episode_rz_pay_init.model.dart';
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

  Future<EpisodeRentModel> getEpisodeRents(String search) async {
    return await networkManager.makeRequest<EpisodeRentModel>(
      "$path/episode-rents/$search/",
      (data) => EpisodeRentModel.fromJson(data),
    );
  }

  Future<PhonePeInit> phonePeInitMovie(String search) async {
    return await networkManager.makeRequest<PhonePeInit>(
        "/movie?id=$search", (data) => PhonePeInit.fromJson(data),
        method: "POST", useSecondaryDio: true);
  }
  Future<RzPayInit> rzPayInitMovie(String search) async {
    return await networkManager.makeRequest<RzPayInit>(
        "/payment/rent/movie", (data) => RzPayInit.fromJson(data),
        data:FormData.fromMap({"id": search,"rz_pay":true}) ,
        method: "POST",);
  }

  Future<EpisodePhonePeInit> phonePeInitEpisode(String search) async {
    return await networkManager.makeRequest<EpisodePhonePeInit>(
      "/payment/rent/episode",
      data: FormData.fromMap({"id": search}),
      (data) => EpisodePhonePeInit.fromJson(data),
      method: "POST",
    );
  }
  Future<RzPayInit> razorPeInitEpisode(String search) async {
    return await networkManager.makeRequest<RzPayInit>(
      "/payment/rent/episode",
      data: FormData.fromMap({"id": search, "rz_pay":true}),
      (data) => RzPayInit.fromJson(data),
      method: "POST",
    );
  }
}
