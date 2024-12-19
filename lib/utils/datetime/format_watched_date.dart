import 'package:intl/intl.dart';

String formatWatchedDate(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays < 1) {
    final timeFormat = DateFormat('hh:mm a');
    return timeFormat.format(dateTime);
  } else {
    final day = dateTime.day;
    final monthFormat = DateFormat('MMM');
    final year = dateTime.year;

    final suffix = getDaySuffix(day);
    final formattedDate = '$day$suffix ${monthFormat.format(dateTime)}, $year';
    return formattedDate;
  }
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
