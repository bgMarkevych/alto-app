import 'dart:io';

import 'package:native_pdf_renderer/native_pdf_renderer.dart';

abstract class FillerFile {
  bool isFolder;
  String path;
  String name;
  String date;
  String extension;

  FillerFile(this.isFolder, this.path, this.name, this.date, this.extension);
}

class StorageFile extends FillerFile {
  StorageFile(isFolder, path, name, date, extension)
      : super(isFolder, path, name, date, extension);
}

class DropboxFile extends FillerFile {
  DropboxFile(isFolder, path, name, date, extension)
      : super(isFolder, path, name, date, extension);
}

enum EcoSystem { STORAGE, GOOGLE, DROPBOX, ONEDRIVE }

class Progress {
//  UPLOAD, PENDING, START, FINISH
  static final String UPLOAD = "UPLOAD";
  static final String WS_CONNECTION = "WS_CONNECTION";
  static final String PENDING = "PENDING";
  static final String START = "START";
  static final String FINISH = "FINISH";
}

class PagesContainer{
  final List<PDFPageImage> pages;
  final String filePath;

  PagesContainer(this.pages, this.filePath);

}

class User{
  final String email;
  final String photoUrl;

  User(this.email, this.photoUrl);

}
