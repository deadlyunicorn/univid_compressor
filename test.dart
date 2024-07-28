import "dart:io";

void main() {
  final newFile = File("hello/johny.txt");
  print(newFile.path.replaceFirst("${newFile.parent.path}/", ""));
}
