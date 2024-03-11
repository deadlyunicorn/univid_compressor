String fileSizeToText(num number) {
  double previousNumber = number.toDouble();
  double currentNumber = previousNumber;

  for (int i = 0; true; i++) {
    currentNumber = currentNumber / 1024;

    final String fixedNumber = currentNumber.toStringAsFixed(2);
    final int decimalPointIndex = fixedNumber.indexOf(".");

    if (fixedNumber[decimalPointIndex - 1] == "0" &&
        fixedNumber[decimalPointIndex + 1] == "0" && fixedNumber.length == 4) {
      return i < 9
          ? i == 0
              ? "${previousNumber.toInt()} bytes"
              : "${previousNumber.toStringAsFixed(2)} ${indexConverter(i)}"
          : "${number.toInt()} bytes";
    }

    previousNumber = currentNumber;
  }

}

String indexConverter(int i) {
  switch (i) {
    case 1:
      return "KiB";
    case 2:
      return "MiB";
    case 3:
      return "GiB";
    case 4:
      return "TiB";
    case 5:
      return "PiB";
    case 6:
      return "EiB";
    case 7:
      return "ZiB";
    case 8:
      return "YiB";
    case 9:
      return "SiB";
    default:
      return "bytes";
  }
}
