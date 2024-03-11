import "package:flutter_test/flutter_test.dart";
import "package:univid_compressor/core/business/file_size_to_text.dart";

void main() {
  test("sample byte tests", () async {
    int twentyFour = 24;
    double nineHundred = 1024 * 0.91;
    int fourKilo = 1024 * 4;
    int ninetyTwoKilo = 1024 * 92;
    double fourTwentyKilo = 1024 * 420;
    double pointFiftyFourMega = 1024 * 1024 * 0.54;
    double fivePointOFiveMega = 1024 * 1024 * 5.05;
    double eightHundredMega = 1024 * 1024 * 800;
    double nineGigs = 1024 * 1024 * 1024 * 9;
    double ninePointFiftyFourGigs = 1024 * 1024 * 1024 * 9.54;

    expectWithConverter(twentyFour, "24 bytes");
    expectWithConverter(nineHundred, "0.91 KiB");
    expectWithConverter(nineHundred, "0.91 KiB");
    expectWithConverter(fourKilo, "4.00 KiB");
    expectWithConverter(ninetyTwoKilo, "92.00 KiB");
    expectWithConverter(fourTwentyKilo, "0.41 MiB");
    expectWithConverter(pointFiftyFourMega, "0.54 MiB");
    expectWithConverter(fivePointOFiveMega, "5.05 MiB");
    expectWithConverter(eightHundredMega, "0.78 GiB");
    expectWithConverter(nineGigs, "9.00 GiB");
    expectWithConverter(ninePointFiftyFourGigs, "9.54 GiB");
  });
}

void expectWithConverter(num number, Object expectAs) {
  expect(fileSizeToText(number), expectAs);
}
