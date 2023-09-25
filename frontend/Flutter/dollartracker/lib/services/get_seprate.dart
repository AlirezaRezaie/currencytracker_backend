String separateNumberWithCommas(int number) {
  String numberStr = number.toString();
  String separatedNumber = '';

  int length = numberStr.length;
  int startIndex = length % 3;

  if (startIndex != 0) {
    separatedNumber += numberStr.substring(0, startIndex) + ',';
  }

  for (int i = startIndex; i < length; i += 3) {
    separatedNumber += numberStr.substring(i, i + 3);
    if (i + 3 < length) {
      separatedNumber += ',';
    }
  }

  return separatedNumber;
}
