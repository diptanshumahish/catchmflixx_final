import 'package:catchmflixx/api/common/network.dart';
import 'package:catchmflixx/models/cast/cast.model.dart';
import 'package:catchmflixx/models/content/movie/movie.model.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:catchmflixx/models/content/series/continue.watching.model.dart';
import 'package:catchmflixx/models/content/series/episodes.model.dart';
import 'package:catchmflixx/models/content/series/seasons.model.dart';
import 'package:catchmflixx/models/language/lang.model.dart';

class ContentManager {
  final NetworkManager networkManager = NetworkManager();
  String path = "content/";

  Future<ContentList> searchContent(String search) async {
    final lang = await networkManager.getLang();
    return await networkManager.makeRequest<ContentList>(
      "$path$lang/list?search=$search",
      (data) => ContentList.fromJson(data),
    );
  }

  Future<SeriesSeasons> getSeasonsData(String uuid) async {
    final lang = await networkManager.getLang();
    return await networkManager.makeRequest<SeriesSeasons>(
      "$path$lang/details/$uuid",
      (data) => SeriesSeasons.fromJson(data),
    );
  }

  Future<MovieFullModel> getMovie(String uuid) async {
    final lang = await networkManager.getLang();
    return await networkManager.makeRequest<MovieFullModel>(
      "$path$lang/details/$uuid",
      (data) => MovieFullModel.fromJson(data),
    );
  }

  Future<EpisodesModel> getEpisodes(String uuid) async {
    final lang = await networkManager.getLang();
    return await networkManager.makeRequest<EpisodesModel>(
      "$path$lang/season-details/$uuid",
      (data) => EpisodesModel.fromJson(data),
    );
  }

  Future<CastResponse> getCast(String uuid) async {
    return await networkManager.makeRequest<CastResponse>(
      "$path/cast/$uuid",
      (data) => CastResponse.fromJson(data),
    );
  }

  Future<LanguageModel> getLanguages(String uuid) async {
    return await networkManager.makeRequest<LanguageModel>(
      "$path/languages/$uuid",
      (data) => LanguageModel.fromJson(data),
    );
  }

  Future<CurrentWatching> continueWatching(String uuid) async {
    return await networkManager.makeRequest<CurrentWatching>(
      "$path/continue-watching/$uuid",
      (data) => CurrentWatching.fromJson(data),
    );
  }
}
