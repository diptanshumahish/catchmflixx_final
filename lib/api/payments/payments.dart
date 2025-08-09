import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/payments/episode_rent_options.dart';
import 'package:catchmflixx/models/payments/episode_rz_pay_init.model.dart';
import 'package:catchmflixx/models/payments/initi_phonepe_subscription.model.dart';
import 'package:catchmflixx/models/payments/phonepe_init.model.dart';
import 'package:catchmflixx/models/payments/renting_options.model.dart';
import 'package:catchmflixx/models/payments/season_rent_options.dart';
import 'package:catchmflixx/models/payments/subscription_model.dart';
import 'package:dio/dio.dart';

class PaymentsManager {
  final NetworkManager networkManager = NetworkManager();
  String path = "payment";

  Future<RentingOptions?> getMovieRents(String search) async {
    return await networkManager.makeRequest<RentingOptions>(
      "$path/movie-rents/$search",
      (data) => RentingOptions.fromJson(data),
    );
  }

  Future<EpisodeRentModel?> getEpisodeRents(String search) async {
    return await networkManager.makeRequest<EpisodeRentModel>(
      "$path/episode-rents/$search/",
      (data) => EpisodeRentModel.fromJson(data),
    );
  }

  Future<SeasonRentModel?> getSeasonRents(String search) async {
    return await networkManager.makeRequest<SeasonRentModel>(
      "$path/season-rents/$search/",
      (data) => SeasonRentModel.fromJson(data),
    );
  }

  Future<SubscriptionPlans?> getSubscriptions() async {
    return await networkManager.makeRequest<SubscriptionPlans>(
      "user/available/plans",
      (data) => SubscriptionPlans.fromJson(data),
    );
  }

  Future<PhonePePaymentSubscription?> paySubscription(String id) async {
    return await networkManager.makeRequest<PhonePePaymentSubscription>(
      "payment/initiate_payment/?plan=$id",
      (data) => PhonePePaymentSubscription.fromJson(data),
    );
  }

  Future<PhonePeInit?> phonePeInitMovie(String search) async {
    return await networkManager.makeRequest<PhonePeInit>(
        "/movie?id=$search", (data) => PhonePeInit.fromJson(data),
        method: "POST", useSecondaryDio: true);
  }

  Future<RzPayInit?> rzPayInitMovie(String search) async {
    return await networkManager.makeRequest<RzPayInit>(
      "/payment/rent/movie",
      (data) => RzPayInit.fromJson(data),
      data: FormData.fromMap({"id": search, "rz_pay": true}),
      method: "POST",
    );
  }

  Future<PhonePePaymentSubscription?> phonePeInitEpisode(String search) async {
    return await networkManager.makeRequest<PhonePePaymentSubscription>(
      "/payment/rent/episode",
      data: FormData.fromMap({"id": search}),
      (data) => PhonePePaymentSubscription.fromJson(data),
      method: "POST",
    );
  }

  Future<RzPayInit?> razorPeInitEpisode(String search) async {
    return await networkManager.makeRequest<RzPayInit>(
      "/payment/rent/episode",
      data: FormData.fromMap({"id": search, "rz_pay": true}),
      (data) => RzPayInit.fromJson(data),
      method: "POST",
    );
  }

  Future<PhonePePaymentSubscription?> phonePeInitSeason(String search) async {
    return await networkManager.makeRequest<PhonePePaymentSubscription>(
      "/payment/rent/season",
      data: FormData.fromMap({"id": search}),
      (data) => PhonePePaymentSubscription.fromJson(data),
      method: "POST",
    );
  }

  Future<RzPayInit?> razorPeInitSeason(String search) async {
    return await networkManager.makeRequest<RzPayInit>(
      "/payment/rent/season",
      data: FormData.fromMap({"id": search, "rz_pay": true}),
      (data) => RzPayInit.fromJson(data),
      method: "POST",
    );
  }
}
