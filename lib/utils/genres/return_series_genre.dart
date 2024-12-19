import 'package:catchmflixx/models/content/series/seasons.model.dart';

String returnSeriesGenres(List<Genres>? genres) {
  if (genres != null) {
    return genres
        .where((genre) => genre.name != null)
        .map((genre) => genre.name!)
        .join(', ');
  }
  return "";
}
