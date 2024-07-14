String returnQuality(String value) {
  switch (value) {
    case "Auto":
      return "Auto";
    case "640x360":
      return "360p";
    case "960x540":
      return "480p";
    case "1280x720":
      return "720p";
    case "1920x1080":
      return "2k";
    case "2560x1440":
      return "4k";
    default:
      return value;
  }
}
