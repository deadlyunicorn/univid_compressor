class NoFilesFoundExcepetion implements Exception {}

class FileErrorException implements Exception {
  final String fileName;
  FileErrorException({
    required this.fileName,
  });
}

class MessageException implements Exception {
  MessageException({required this.message});
  String message;
}

class SystemNotSupportedException implements Exception {}

class MD5CheckFailedException implements Exception {}

class NotAllowedException extends MessageException {
  NotAllowedException() : super(message: "Action not allowed");
}
