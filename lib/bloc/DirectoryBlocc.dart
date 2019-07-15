import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:bloc/bloc.dart';
import 'package:test_app/events/MainEvent.dart';
import 'package:test_app/events/SubDirectoryEvent.dart';
import 'package:test_app/model/FilePicker.dart';
import 'package:test_app/events/AbsEvent.dart';
import 'package:test_app/screens/LoadingScreen.dart';
import 'package:test_app/events/RootEvent.dart';
import 'package:test_app/states/AbsState.dart';
import 'package:test_app/states/RootState.dart';
import 'package:test_app/states/LoadingState.dart';

import 'Blocc.dart';

class DirectoryBlocc extends Bloc<AbsEvent, AbsState> {
  final FilePicker filePicker;
  final Blocc blocc;

  DirectoryBlocc(this.filePicker, this.blocc);

  @override
  AbsState get initialState => LoadingState();

  @override
  Stream<AbsState> mapEventToState(AbsEvent event) async* {
    if (event is RootEvent) {
      yield LoadingState();
      bool externalStoragePermissionOkay = false;
      if (Platform.isAndroid) {
        await SimplePermissions.checkPermission(Permission.WriteExternalStorage)
            .then((checkOkay) {
          if (!checkOkay) {
            SimplePermissions.requestPermission(Permission.WriteExternalStorage)
                .then((okDone) {
              if (okDone == PermissionStatus.authorized) {
                externalStoragePermissionOkay = true;
              }
            });
          } else {
            externalStoragePermissionOkay = checkOkay;
          }
        });
        if (!externalStoragePermissionOkay) {
          blocc..dispatch(MainEvent());
          return;
        }
      }
      var directory = await filePicker.fetchRoot();
      yield RootState(directory);
    }
  }
}
