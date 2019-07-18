import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import 'data.dart';

abstract class BasicEvent extends Equatable {}

class SplashEvent extends BasicEvent {}

class MainEvent extends BasicEvent {}

class EcoSystemSelectedEvent extends BasicEvent {
  String data;
  EcoSystem type;

  EcoSystemSelectedEvent(this.data, this.type);

}

class FilesEvent extends BasicEvent {
  EcoSystem type;

  FilesEvent(this.type);
}

class RootFolderEvent extends BasicEvent {
  EcoSystem type;

  RootFolderEvent(this.type);
}

class SubFolderEvent extends BasicEvent {
  FillerFile file;

  SubFolderEvent(this.file);
}

class GoBackEvent extends BasicEvent {}

class LoadingEvent extends BasicEvent {}

class ErrorEvent extends BasicEvent {}

class RenderPDFEvent extends BasicEvent {
  String path;

  RenderPDFEvent(this.path);
}

class ConvertEvent extends BasicEvent {
  String path;

  ConvertEvent(this.path);
}

class ExportEvent extends BasicEvent {
  String url;
  String newName;
  String oldFilePath;

  ExportEvent(this.url, this.newName, this.oldFilePath);
}

class DownloadEvent extends BasicEvent {
  String url;
  String fileName;
  Subject downloadListener;

  DownloadEvent(this.url, this.fileName, this.downloadListener);
}

class LoginEvent extends BasicEvent{}
