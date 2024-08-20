// DateTime Object to Formatted String
import 'package:intl/intl.dart';

// Parse DateTime to Date and Time
String parseDateTime(DateTime dateTime) {
  // Format to 17 Dec 2000, 12:08 PM
  return DateFormat('d MMM y, hh:mm a').format(dateTime);
}

// Parse DateTime to Date
String parseDate(DateTime dateTime) {
  // Format to 17 Dec 2000
  return DateFormat('d MMM y').format(dateTime);
}

// Parse DateTime to Time AM/PM
String parseTime(DateTime? dateTime) {
  if (dateTime == null) return ' -- : -- ';
  // Format to 12:08 PM
  return DateFormat('hh : mm a').format(dateTime);
}

// Parse DateTime to Time Only
String parseTimeOnly(DateTime? dateTime) {
  // print('parseTimeOnly: $dateTime');
  if (dateTime == null) return ' -- : -- ';
  // Format to 12:08
  return DateFormat(' hh : mm ').format(dateTime);
}

// Parse DateTime to Only AM/PM
String parseAmPm(DateTime? dateTime) {
  if (dateTime == null) return ' -- ';
  // Format to PM
  return DateFormat('a').format(dateTime);
}

// Parse Difference between two DateTime
String parseTimeDifference({
  required DateTime endTime,
  required DateTime startTime,
}) {
  final difference = endTime.difference(startTime);
  final days = difference.inDays;
  final hours = difference.inHours.remainder(24);
  final minutes = difference.inMinutes.remainder(60);

  if (days > 0) {
    return '$days ${days == 1 ? 'Day' : 'Days'} $hours ${hours == 1 ? 'Hr' : 'Hrs'} $minutes ${minutes == 1 ? 'Min' : 'Mins'}';
  } else if (hours > 0) {
    return '$hours ${hours == 1 ? 'Hr' : 'Hrs'} $minutes ${minutes == 1 ? 'Min' : 'Mins'}';
  } else {
    return '$minutes ${minutes == 1 ? 'Min' : 'Mins'}';
  }
}
