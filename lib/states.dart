import 'package:equatable/equatable.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:rxdart/rxdart.dart';

import 'data.dart';

abstract class BasicState extends Equatable {}

class SplashState extends BasicState {}

class MainState extends BasicState {}

class EcoSystemSelectedState extends BasicState {}

class FilesState extends BasicState {
  EcoSystem type;

  FilesState(this.type);
}

class RootFolderState extends BasicState {
  List<FillerFile> files;

  RootFolderState(this.files);
}

class SubFolderState extends BasicState {
  String name;
  List<FillerFile> files;

  SubFolderState(this.files, this.name);
}

class LoadingState extends BasicState {}

class ErrorState extends BasicState {}

class RenderPDFState extends BasicState {
  List<PDFPageImage> pages;
  String filePath;

  RenderPDFState(this.pages, this.filePath);
}

class ConvertState extends BasicState {
  String fileName;
  Subject progressListener;

  ConvertState(this.fileName, this.progressListener);
}

class ExportState extends BasicState {
  String fileName;
  String url;
  String oldPath;

  ExportState(this.fileName, this.url, this.oldPath);
}

class LoginState extends BasicState{}
