class M3U8Data {
  final String? dataQuality;
  final String? dataURL;
  final List<AudioTrack> audioTracks;

  M3U8Data({this.dataQuality, this.dataURL, this.audioTracks = const []});
}

class AudioTrack {
  final String language;
  final String name;
  final String url;

  AudioTrack({required this.language, required this.name, required this.url});
}
