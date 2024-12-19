import 'package:catchmflixx/models/content/movie/movie.model.dart';

String returnGenres(List<Genres>? genres) {
  if (genres != null) {
    return genres
        .where((genre) => genre.name != null)
        .map((genre) => genre.name!)
        .join(', ');
  }
  return "";
}
