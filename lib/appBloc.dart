import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/data.dart';
import 'package:test_app/events.dart';
import 'package:test_app/repository.dart';
import 'package:test_app/states.dart';
import 'widgets.dart';
import 'storage.dart';

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
  BuildContext context;
  User user;

  FilesBloc(this.filePicker, this.context);

  @override
  BasicState get initialState => EcoSystemSelectedState();

  @override
  Stream<BasicState> mapEventToState(BasicEvent event) async* {
    if (event is EcoSystemSelectedEvent) {
      bool hasToken = await filePicker.hasToken();
      if (event.type != EcoSystem.STORAGE && !hasToken) {
        yield LoginState();
        return;
      }
      yield EcoSystemSelectedState();
      showLoadingDialog(context);
      List<FillerFile> files = await filePicker.routeToRoot();
      user = await filePicker.getUser();
      Navigator.pop(context);
      yield RootFolderState(files, user);
    }
    if (event is LoginEvent) {
      yield EcoSystemSelectedState();
      showLoadingDialog(context);
      await filePicker.getToken(event.code);
      List<FillerFile> files = await filePicker.routeToRoot();
      user = await filePicker.getUser();
      Navigator.pop(context);
      yield RootFolderState(files, user);
    }
    if (event is GoBackEvent) {
      showLoadingDialog(context);
      List<FillerFile> files = await filePicker.onBackPress();
      Navigator.pop(context);
      if (filePicker.isRoot) {
        yield RootFolderState(files, user);
      } else {
        yield SubFolderState(files, filePicker.currentItem.name);
      }
    }
    if (event is SubFolderEvent) {
      showLoadingDialog(context);
      List<FillerFile> files = await filePicker.routeToNextFolder(event.file);
      Navigator.pop(context);
      yield SubFolderState(files, filePicker.currentItem.name);
    }
    if (event is RenderPDFEvent) {
      showLoadingDialog(context);
      PagesContainer container = await filePicker.renderPdfDocument(event.path);
      Navigator.pop(context);
      yield RenderPDFState(container.pages, container.filePath);
    }
    if (event is ConvertEvent) {
      Subject progressListener = PublishSubject();
      yield ConvertState(basename(event.path), progressListener);
      filePicker.convert(File(event.path), progressListener);
    }
    if (event is ExportEvent) {
      yield ExportState(event.newName, event.url, event.oldFilePath);
    }
    if (event is DownloadEvent) {
      filePicker.downloadFile(
          event.url, event.fileName, event.downloadListener);
    }
    if (event is ErrorEvent) {
      yield ErrorState();
    }
    if (event is LogoutEvent) {
      showLoadingDialog(context);
      await filePicker.logout();
      Navigator.pop(context);
      final globalBloc = BlocProvider.of<GlobalBloc>(context);
      globalBloc.dispatch(MainEvent());
    }
  }
}
