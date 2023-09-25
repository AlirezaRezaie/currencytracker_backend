export 'package:dollartracker/services/extract_hours.dart';

double extractHour(String time) {
  // Split the time string into hours and minutes
  List<String> parts = time.split(':');

  if (parts.length != 2) {
    throw FormatException("Invalid time format. Expected 'HH:mm'.");
  }

  // Extract the hour and parse it as an integer
  int? hour = int.tryParse(parts[0]);
  int? minutes = int.tryParse(parts[1]);
  int floating_minutes = (hour! * 60) + minutes!;

  if (hour! < 0 || hour > 23) {
    throw FormatException("Invalid hour value.");
  }
  print(hour);
  return ((floating_minutes) / (1440)) * (24);
}
