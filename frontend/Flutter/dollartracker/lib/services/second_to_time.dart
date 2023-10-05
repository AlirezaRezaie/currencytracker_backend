String SecondToTime(int second) {
  int totalSeconds = second;

  int hours = totalSeconds ~/ 3600;
  int remainingSeconds = totalSeconds % 3600;

  int minutes = remainingSeconds ~/ 60;
  int seconds = remainingSeconds % 60;

  String timeFormat =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  return timeFormat;
}
