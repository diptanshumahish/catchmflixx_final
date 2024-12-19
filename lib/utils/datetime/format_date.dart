import 'package:intl/intl.dart';

String formatDate(String input) {
  DateTime dateTime = DateFormat('dd-MM-yyyy HH:mm:ss').parse(input);
  int day = dateTime.day;
  String month = DateFormat('MMMM').format(dateTime);
  int year = dateTime.year;
  String daySuffix;
  if (day == 1 || day == 21 || day == 31) {
    daySuffix = 'st';
  } else if (day == 2 || day == 22) {
    daySuffix = 'nd';
  } else if (day == 3 || day == 23) {
    daySuffix = 'rd';
  } else {
    daySuffix = 'th';
  }

  String formattedTime = DateFormat('h:mm a').format(dateTime);
  String formattedDate = '$day$daySuffix $month, $year at $formattedTime';

  return formattedDate;
}
