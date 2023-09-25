export 'package:dollartracker/services/extract_hours.dart';

int extractHour(String time) {
  // Split the time string into hours and minutes
  List<String> parts = time.split(':');

  if (parts.length != 2) {
    throw FormatException("Invalid time format. Expected 'HH:mm'.");
  }

  // Extract the hour and parse it as an integer
  int? hour = int.tryParse(parts[0]);

  if (hour == null || hour < 0 || hour > 23) {
    throw FormatException("Invalid hour value.");
  }

  return hour;
}
