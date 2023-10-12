String getTimeForIran(String time) {
  // Time strings in "HH:mm" or "HH:mm:ss" format
  String time1String = time;
  String time2String = "03:30:00"; // Add seconds for the second time

  // Split the time strings into their components
  List<String> time1Parts = time1String.split(':');
  List<String> time2Parts = time2String.split(':');

  int hours1 = int.parse(time1Parts[0]);
  int minutes1 = int.parse(time1Parts[1]);
  int seconds1 =
      time1Parts.length > 2 ? int.parse(time1Parts[2]) : 0; // Handle seconds

  int hours2 = int.parse(time2Parts[0]);
  int minutes2 = int.parse(time2Parts[1]);
  int seconds2 =
      time2Parts.length > 2 ? int.parse(time2Parts[2]) : 0; // Handle seconds

  Duration time1 = Duration(
      hours: hours1, minutes: minutes1, seconds: seconds1); // Include seconds
  Duration time2 = Duration(
      hours: hours2, minutes: minutes2, seconds: seconds2); // Include seconds

  // Add the two Duration objects together
  Duration totalTime = time1 + time2;

  // If total time exceeds 24 hours, subtract 24 hours to keep it within one day
  if (totalTime.inHours >= 24) {
    totalTime -= Duration(hours: 24);
  }

  // Extract hours, minutes, and seconds from the totalTime
  int totalHours = totalTime.inHours;
  int totalMinutes = totalTime.inMinutes.remainder(60);
  int totalSeconds = totalTime.inSeconds.remainder(60);

  // Determine the format based on whether seconds are included in the input
  String result;
  if (seconds1 > 0 || seconds2 > 0) {
    // Format as "HH:mm:ss" if seconds are present
    result =
        '${totalHours.toString().padLeft(2, '0')}:${totalMinutes.toString().padLeft(2, '0')}:${totalSeconds.toString().padLeft(2, '0')}';
  } else {
    // Format as "HH:mm" if no seconds are present
    result =
        '${totalHours.toString().padLeft(2, '0')}:${totalMinutes.toString().padLeft(2, '0')}';
  }

  return result;
}
