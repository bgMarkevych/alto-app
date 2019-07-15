import 'dart:io';

abstract class FilePicker {
  Future<Directory> fetchRoot();

  Future<Directory> fetchDirectory(String path);

  Future<File> fetchFile(String path);

}
