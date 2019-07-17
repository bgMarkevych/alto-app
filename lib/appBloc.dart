import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/data.dart';
import 'package:test_app/events.dart';
import 'package:test_app/repository.dart';
import 'package:test_app/states.dart';

class GlobalBloc extends Bloc<BasicEvent, BasicState> {
  @override
  BasicState get initialState => SplashState();

  @override
  Stream<BasicState> mapEventToState(BasicEvent event) async* {
    if (event is SplashEvent) {
      yield SplashState();
      await Future.delayed(Duration(seconds: 2));
      yield MainState();
    }
    if (event is MainEvent) {
      yield MainState();
    }
    if (event is FilesEvent) {
      yield FilesState(event.type);
    }
  }
}

class FilesBloc extends Bloc<BasicEvent, BasicState> {
  FilePicker filePicker;

  FilesBloc(this.filePicker);

  @override
  BasicState get initialState => EcoSystemSelectedState();

  @override
  Stream<BasicState> mapEventToState(BasicEvent event) async* {
    if (event is EcoSystemSelectedEvent) {
      yield EcoSystemSelectedState();
      List<FillerFile> files = await filePicker.routeToRoot();
      yield RootFolderState(files);
    }
    if (event is GoBackEvent) {
      List<FillerFile> files = await filePicker.onBackPress();
      if (filePicker.isRoot) {
        yield RootFolderState(files);
      } else {
        yield SubFolderState(files, filePicker.currentItem.name);
      }
    }
    if (event is SubFolderEvent) {
      List<FillerFile> files = await filePicker.routeToNextFolder(event.file);
      yield SubFolderState(files, filePicker.currentItem.name);
    }
    if (event is RenderPDFEvent) {
      yield LoadingState();
      List<PDFPageImage> pages = await filePicker.renderPdfDocument(event.path);
      yield RenderPDFState(pages, event.path);
    }
    if (event is ConvertEvent) {
      Subject progressListener = PublishSubject();
      yield ConvertState(basename(event.path), progressListener);
      filePicker.convert(File(event.path), progressListener);
    }
    if (event is ExportEvent) {
      yield ExportState(event.newName, event.url, event.oldFilePath);
    }
    if(event is DownloadEvent){
      filePicker.downloadFile(event.url, event.fileName, event.downloadListener);
    }
    if (event is ErrorEvent) {
      yield ErrorState();
    }
  }
}
