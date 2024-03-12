import "package:flutter_test/flutter_test.dart";
import "package:univid_compressor/core/video_details.dart";

void main() {
  test("shortening file names", () {
    const String name01 = "jazz.mp4";
    const String name02 = "ok";
    const String name03 = "012345678012345678";
    const String name04 = "012345678012345678.png";
    const String name06 = "012345678012345678012345678.png";

    String testLoopText = "";
    for (int i = 0; i < 28; i++, testLoopText += "0") {
      expectHandler(testLoopText, testLoopText);
    }

    testLoopText = "";
    for (int i = 0; i < 100; i++, testLoopText += "0") {
      expect(
        VideoDetails.getShortFileName(fileName: testLoopText).length <= 27,
        true,
      );
    }
    expectHandler(name01, "jazz.mp4");
    expectHandler(name02, "ok");
    expectHandler(name03, "012345678012345678");
    expectHandler(name04, "012345678012345678.png");
    expectHandler(name06, "012345678012...12345678.png");
    expectHandler(name06 + name06, "012345678012...12345678.png");
    expectHandler(
      name06 + name01 + name01 + name01,
      "012345678012....mp4jazz.mp4",
    );
  });
}

void expectHandler(String fileName, Object toExpectAs) {
  expect(VideoDetails.getShortFileName(fileName: fileName), toExpectAs);
}
