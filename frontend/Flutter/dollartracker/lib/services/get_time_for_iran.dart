export 'package:dollartracker/services/get_time_for_iran.dart';

String getTimeForIran(String time) {
  // Time strings in "HH:mm" format
  String time1String = time;
  String time2String = "03:30";
  // Parse the time strings into Duration objects
  List<String> time1Parts = time1String.split(':');
  List<String> time2Parts = time2String.split(':');

  int hours1 = int.parse(time1Parts[0]);
  int minutes1 = int.parse(time1Parts[1]);

  int hours2 = int.parse(time2Parts[0]);
  int minutes2 = int.parse(time2Parts[1]);

  Duration time1 = Duration(hours: hours1, minutes: minutes1);
  Duration time2 = Duration(hours: hours2, minutes: minutes2);

  // Add the two Duration objects together
  Duration totalTime = time1 + time2;

  // If total time exceeds 24 hours, subtract 24 hours to keep it within one day
  if (totalTime.inHours >= 24) {
    totalTime -= Duration(hours: 24);
  }

  // Extract hours and minutes from the totalTime
  int totalHours = totalTime.inHours;
  int totalMinutes = totalTime.inMinutes.remainder(60);

  // Format the result as "HH:mm"
  String result =
      '${totalHours.toString().padLeft(2, '0')}:${totalMinutes.toString().padLeft(2, '0')}';

  return result;
}
